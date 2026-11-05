using System.Text.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using VisitDreznica.Model.Messaging;

namespace VisitDreznica.Worker.Email;

public class EmailQueueConsumer(
    RabbitMqSettings rabbitSettings,
    IEmailSender emailSender,
    ILogger<EmailQueueConsumer> logger) : BackgroundService
{
    private const string RetryCountHeader = "x-retry-count";

    private static readonly TimeSpan[] RetryDelays =
        [TimeSpan.FromSeconds(10), TimeSpan.FromMinutes(1), TimeSpan.FromMinutes(5)];

    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private IConnection? connection;
    private IChannel? channel;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var activeChannel = await ConnectAsync(stoppingToken);
        channel = activeChannel;

        await DeclareTopologyAsync(activeChannel, stoppingToken);
        await activeChannel.BasicQosAsync(prefetchSize: 0, prefetchCount: 1, global: false, cancellationToken: stoppingToken);

        var consumer = new AsyncEventingBasicConsumer(activeChannel);
        consumer.ReceivedAsync += (_, args) => HandleAsync(activeChannel, args);

        await activeChannel.BasicConsumeAsync(EmailQueues.Send, autoAck: false, consumer: consumer,
            cancellationToken: stoppingToken);

        logger.LogInformation("Worker sluša red {Queue}", EmailQueues.Send);

        await Task.Delay(Timeout.Infinite, stoppingToken);
    }

    private async Task<IChannel> ConnectAsync(CancellationToken stoppingToken)
    {
        var factory = new ConnectionFactory
        {
            HostName = rabbitSettings.Host,
            Port = rabbitSettings.Port,
            UserName = rabbitSettings.User,
            Password = rabbitSettings.Password,
            AutomaticRecoveryEnabled = true,
            ClientProvidedName = "VisitDreznica.Worker"
        };

        while (true)
        {
            try
            {
                connection = await factory.CreateConnectionAsync(stoppingToken);
                return await connection.CreateChannelAsync(cancellationToken: stoppingToken);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogWarning("RabbitMQ nije dostupan ({Error}), novi pokušaj za 5 sekundi", ex.Message);
                await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
            }
        }
    }

    private static async Task DeclareTopologyAsync(IChannel activeChannel, CancellationToken cancellationToken)
    {
        await activeChannel.QueueDeclareAsync(EmailQueues.Send, durable: true, exclusive: false, autoDelete: false,
            arguments: null, cancellationToken: cancellationToken);

        await activeChannel.QueueDeclareAsync(EmailQueues.Dead, durable: true, exclusive: false, autoDelete: false,
            arguments: null, cancellationToken: cancellationToken);

        for (var i = 0; i < RetryDelays.Length; i++)
        {
            await activeChannel.QueueDeclareAsync(EmailQueues.Retry(i + 1), durable: true, exclusive: false,
                autoDelete: false,
                arguments: new Dictionary<string, object?>
                {
                    ["x-message-ttl"] = (int)RetryDelays[i].TotalMilliseconds,
                    ["x-dead-letter-exchange"] = string.Empty,
                    ["x-dead-letter-routing-key"] = EmailQueues.Send
                },
                cancellationToken: cancellationToken);
        }
    }

    private async Task HandleAsync(IChannel activeChannel, BasicDeliverEventArgs args)
    {
        var retryCount = GetRetryCount(args.BasicProperties);
        EmailMessage? message = null;

        try
        {
            message = JsonSerializer.Deserialize<EmailMessage>(args.Body.Span, JsonOptions);
        }
        catch (JsonException ex)
        {
            logger.LogError(ex, "Poruka nije ispravan EmailMessage");
        }

        if (message is null)
        {
            await RepublishAsync(activeChannel, args, EmailQueues.Dead, retryCount);
            await activeChannel.BasicAckAsync(args.DeliveryTag, multiple: false);
            return;
        }

        try
        {
            await emailSender.SendAsync(message);
            logger.LogInformation("Email {MessageId} poslan", message.Id);
        }
        catch (Exception ex)
        {
            if (ex is not PermanentEmailException && retryCount < RetryDelays.Length)
            {
                logger.LogWarning(ex, "Email {MessageId} nije poslan, ponovni pokušaj {Attempt} za {Delay}",
                    message.Id, retryCount + 1, RetryDelays[retryCount]);
                await RepublishAsync(activeChannel, args, EmailQueues.Retry(retryCount + 1), retryCount + 1);
            }
            else
            {
                logger.LogError(ex, "Email {MessageId} nije poslan, premješten u {Queue}", message.Id, EmailQueues.Dead);
                await RepublishAsync(activeChannel, args, EmailQueues.Dead, retryCount);
            }
        }

        await activeChannel.BasicAckAsync(args.DeliveryTag, multiple: false);
    }

    private static async Task RepublishAsync(IChannel activeChannel, BasicDeliverEventArgs args, string queue, int retryCount)
    {
        var properties = new BasicProperties
        {
            Persistent = true,
            ContentType = "application/json",
            MessageId = args.BasicProperties.MessageId,
            Headers = new Dictionary<string, object?> { [RetryCountHeader] = retryCount }
        };

        await activeChannel.BasicPublishAsync(exchange: string.Empty, routingKey: queue, mandatory: false,
            basicProperties: properties, body: args.Body);
    }

    private static int GetRetryCount(IReadOnlyBasicProperties properties) =>
        properties.Headers is not null &&
        properties.Headers.TryGetValue(RetryCountHeader, out var value) &&
        value is not null
            ? Convert.ToInt32(value)
            : 0;

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        await base.StopAsync(cancellationToken);

        if (channel is not null) await channel.DisposeAsync();
        if (connection is not null) await connection.DisposeAsync();
    }
}