using DotNetEnv;
using VisitDreznica.Worker.Configuration;
using VisitDreznica.Worker.Email;

Env.NoClobber().TraversePath().Load();

var builder = Host.CreateApplicationBuilder(args);

builder.Services.AddSingleton(builder.Configuration.GetRabbitMqSettings());
builder.Services.AddSingleton(builder.Configuration.GetSmtpSettings());
builder.Services.AddSingleton<IEmailSender, SmtpEmailSender>();
builder.Services.AddHostedService<EmailQueueConsumer>();

builder.Build().Run();