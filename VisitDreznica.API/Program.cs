using DotNetEnv;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using VisitDreznica.API.Configuration;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Seed;
using VisitDreznica.Services.Security;
using Mapster;
using VisitDreznica.API.ErrorHandling;
using VisitDreznica.Services.Locations;

// Učitava .env u environment varijable. U Dockeru .env fajla nema,
// pa vrijednosti dolaze iz docker-compose (NoClobber ih ne pregazi).
Env.NoClobber().TraversePath().Load();

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<VisitDreznicaDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetSqlConnectionString()));

builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<DbSeeder>();
builder.Services.AddMapster();
builder.Services.AddScoped<ICountryService, CountryService>();
builder.Services.AddScoped<ICityService, CityService>();

builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();
app.UseExceptionHandler();

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