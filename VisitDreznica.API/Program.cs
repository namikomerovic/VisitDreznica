using DotNetEnv;
using Mapster;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Scalar.AspNetCore;
using System.Security.Claims;
using System.Text;
using VisitDreznica.API.Configuration;
using VisitDreznica.API.ErrorHandling;
using VisitDreznica.API.Security;
using VisitDreznica.Model.Constants;
using VisitDreznica.Services.Activities;
using VisitDreznica.Services.Auth;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Seed;
using VisitDreznica.Services.Equipments;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Locations;
using VisitDreznica.Services.Lookups;
using VisitDreznica.Services.NewsItems;
using VisitDreznica.Services.Places;
using VisitDreznica.Services.Rooms;
using VisitDreznica.Services.Security;
using VisitDreznica.Services.Users;
using VisitDreznica.Services.Reservations;
using Stripe;
using VisitDreznica.Services.Payments;
using VisitDreznica.API.BackgroundServices;

// Učitava .env u environment varijable. U Dockeru .env fajla nema,
// pa vrijednosti dolaze iz docker-compose (NoClobber ih ne pregazi).
Env.NoClobber().TraversePath().Load();

var builder = WebApplication.CreateBuilder(args);

// ---------- Konfiguracija ----------
var jwtSettings = builder.Configuration.GetJwtSettings();
builder.Services.AddSingleton(jwtSettings);
builder.Services.AddSingleton(builder.Configuration.GetReservationSettings());
var paymentSettings = builder.Configuration.GetPaymentSettings();
builder.Services.AddSingleton(paymentSettings);
builder.Services.AddHttpClient("Stripe");
builder.Services.AddSingleton<IStripeClient>(serviceProvider =>
{
    var httpClient = serviceProvider.GetRequiredService<IHttpClientFactory>().CreateClient("Stripe");
    return new StripeClient(paymentSettings.SecretKey, httpClient: new SystemNetHttpClient(httpClient));
});

// ---------- Baza ----------
builder.Services.AddDbContext<VisitDreznicaDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetSqlConnectionString()));
builder.Services.AddScoped<DbSeeder>();

// ---------- Sigurnost ----------
builder.Services.AddMemoryCache();
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUser, HttpCurrentUser>();
builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<ISessionService, SessionService>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped(typeof(ILookupService<>), typeof(LookupService<>));
builder.Services.AddScoped<IGuideService, GuideService>();
builder.Services.AddScoped<IRoomService, RoomService>();
builder.Services.AddScoped<IEquipmentService, EquipmentService>();
builder.Services.AddScoped(typeof(IEntityImageService<>), typeof(EntityImageService<>));
builder.Services.AddScoped<IActivityService, ActivityService>();
builder.Services.AddScoped<IActivitySlotService, ActivitySlotService>();
builder.Services.AddScoped<IPlaceService, PlaceService>();
builder.Services.AddScoped(typeof(IGalleryImageService<,>), typeof(GalleryImageService<,>));
builder.Services.AddScoped<INewsService, NewsService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IReservationService, ReservationService>();
builder.Services.AddScoped<IRoomReservationService, RoomReservationService>();
builder.Services.AddScoped<IEquipmentReservationService, EquipmentReservationService>();
builder.Services.AddScoped<IActivityReservationService, ActivityReservationService>();
builder.Services.AddScoped<IPaymentService, PaymentService>();
builder.Services.AddScoped<IReservationPaymentService, ReservationPaymentService>();
builder.Services.AddScoped<IReservationExpiryService, ReservationExpiryService>();
builder.Services.AddHostedService<ReservationExpiryWorker>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.MapInboundClaims = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwtSettings.Issuer,
            ValidateAudience = true,
            ValidAudience = jwtSettings.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Secret)),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromSeconds(30),
            NameClaimType = ClaimTypes.Name,
            RoleClaimType = ClaimTypes.Role
        };
        options.Events = new JwtBearerEvents
        {
            OnTokenValidated = async context =>
            {
                var sessionService = context.HttpContext.RequestServices.GetRequiredService<ISessionService>();
                var sessionIdValue = context.Principal?.FindFirstValue(AppClaims.SessionId);

                if (!Guid.TryParse(sessionIdValue, out var sessionId) || !await sessionService.IsActiveAsync(sessionId))
                {
                    context.Fail("Sesija nije aktivna.");
                }
            }
        };
    });
builder.Services.AddAuthorization();

// ---------- Aplikacijski servisi ----------
TypeAdapterConfig.GlobalSettings.Scan(typeof(RoomService).Assembly);
builder.Services.AddMapster();
builder.Services.AddScoped<ICountryService, CountryService>();
builder.Services.AddScoped<ICityService, CityService>();

// ---------- API ----------
builder.Services.AddControllers();
builder.Services.AddOpenApi(options => options.AddDocumentTransformer<BearerSecuritySchemeTransformer>());
builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();

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

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

await app.RunAsync();