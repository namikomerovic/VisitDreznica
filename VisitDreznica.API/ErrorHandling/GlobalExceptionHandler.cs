using Microsoft.AspNetCore.Diagnostics;
using Microsoft.Extensions.Localization;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Resources;

namespace VisitDreznica.API.ErrorHandling;

public class GlobalExceptionHandler(
    ILogger<GlobalExceptionHandler> logger,
    IProblemDetailsService problemDetailsService,
    IStringLocalizer<SharedResource> localizer)
    : IExceptionHandler
{
    private const string ServerErrorMessage = "Došlo je do greške na serveru. Pokušajte ponovo kasnije.";

    public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        var statusCode = exception switch
        {
            NotFoundException => StatusCodes.Status404NotFound,
            BusinessException => StatusCodes.Status400BadRequest,
            UnauthorizedAccessException => StatusCodes.Status401Unauthorized,
            _ => StatusCodes.Status500InternalServerError
        };

        if (statusCode == StatusCodes.Status500InternalServerError)
        {
            logger.LogError(exception, "Neobrađena greška pri obradi zahtjeva {Method} {Path}",
                httpContext.Request.Method, httpContext.Request.Path);
        }
        else
        {
            logger.LogWarning("Zahtjev {Method} {Path} odbijen ({StatusCode}): {Message}",
                httpContext.Request.Method, httpContext.Request.Path, statusCode, exception.Message);
        }

        httpContext.Response.StatusCode = statusCode;

        return await problemDetailsService.TryWriteAsync(new ProblemDetailsContext
        {
            HttpContext = httpContext,
            ProblemDetails = { Status = statusCode, Title = Localize(exception, statusCode) }
        });
    }

    /// <summary>Poruka na jeziku zahtjeva (Accept-Language); bez prijevoda ostaje bosanska.</summary>
    private string Localize(Exception exception, int statusCode)
    {
        if (statusCode == StatusCodes.Status500InternalServerError)
        {
            return localizer[ServerErrorMessage];
        }

        if (exception is LocalizableException localizable)
        {
            // Tekstualni argumenti (npr. naziv vrste zapisa ili status) prevode se ako za njih postoji prijevod.
            var arguments = localizable.Arguments
                .Select(x => x is string text ? (object)localizer[text].Value : x)
                .ToArray();

            return localizer[localizable.Template, arguments];
        }

        return localizer[exception.Message];
    }
}
