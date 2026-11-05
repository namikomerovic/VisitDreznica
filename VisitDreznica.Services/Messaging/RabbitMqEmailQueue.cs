using System.Text.Json;
using Microsoft.Extensions.Logging;
using RabbitMQ.Client;
using VisitDreznica.Model.Messaging;

namespace VisitDreznica.Services.Messaging;

public sealed class RabbitMqEmailQueue(RabbitMqSettings settings, ILogger<RabbitMqEmailQueue> logger)
    : IEmailQueue, IAsyncDisposable
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly SemaphoreSlim gate = new(1, 1);
    private IConnection? connection;
    private IChannel? channel;

    public async Task EnqueueAsync(EmailMessage message)
    {
        await gate.WaitAsync();

        try
        {
            var activeChannel = await GetChannelAsync();

            var properties = new BasicProperties
            {
                Persistent = true,
                ContentType = "application/json",
                MessageId = message.Id.ToString()
            };

            var body = JsonSerializer.SerializeToUtf8Bytes(message, JsonOptions);

            await activeChannel.BasicPublishAsync(exchange: string.Empty, routingKey: EmailQueues.Send,
                mandatory: false, basicProperties: properties, body: body);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Email {MessageId} nije stavljen u red", message.Id);
            await ResetAsync();
        }
        finally
        {
            gate.Release();
        }
    }

    private async Task<IChannel> GetChannelAsync()
    {
        if (channel is { IsOpen: true })
        {
            return channel;
        }

        await ResetAsync();

        var factory = new ConnectionFactory
        {
            HostName = settings.Host,
            Port = settings.Port,
            UserName = settings.User,
            Password = settings.Password,
            AutomaticRecoveryEnabled = true,
            RequestedConnectionTimeout = TimeSpan.FromSeconds(3),
            ClientProvidedName = "VisitDreznica.API"
        };

        connection = await factory.CreateConnectionAsync();
        channel = await connection.CreateChannelAsync();

        await channel.QueueDeclareAsync(EmailQueues.Send, durable: true, exclusive: false, autoDelete: false,
            arguments: null);

        return channel;
    }

    private async Task ResetAsync()
    {
        try
        {
            if (channel is not null) await channel.DisposeAsync();
            if (connection is not null) await connection.DisposeAsync();
        }
        catch (Exception ex)
        {
            logger.LogDebug(ex, "Greška pri zatvaranju RabbitMQ veze");
        }
        finally
        {
            channel = null;
            connection = null;
        }
    }

    public async ValueTask DisposeAsync()
    {
        await ResetAsync();
        gate.Dispose();
    }
}