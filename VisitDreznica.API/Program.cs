using DotNetEnv;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using VisitDreznica.API.Configuration;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Seed;
using VisitDreznica.Services.Security;

// Učitava .env u environment varijable. U Dockeru .env fajla nema,
// pa vrijednosti dolaze iz docker-compose (NoClobber ih ne pregazi).
Env.NoClobber().TraversePath().Load();

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<VisitDreznicaDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetSqlConnectionString()));

builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<DbSeeder>();

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<VisitDreznicaDbContext>();
    await dbContext.Database.MigrateAsync();

    var seeder = scope.ServiceProvider.GetRequiredService<DbSeeder>();
    await seeder.SeedAsync();
}

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseAuthorization();
app.MapControllers();

await app.RunAsync();