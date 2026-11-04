using DotNetEnv;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using VisitDreznica.API.Configuration;
using VisitDreznica.Services.Database;

// Učitava .env u environment varijable. U Dockeru .env fajla nema,
// pa vrijednosti dolaze iz docker-compose (NoClobber ih ne pregazi).
Env.NoClobber().TraversePath().Load();

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<VisitDreznicaDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetSqlConnectionString()));

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<VisitDreznicaDbContext>();
    await dbContext.Database.MigrateAsync();
}

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseAuthorization();
app.MapControllers();

await app.RunAsync();