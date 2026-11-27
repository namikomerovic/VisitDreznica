using System.Globalization;

namespace VisitDreznica.Model.Exceptions;

/// <summary>
/// Izuzetak čija se poruka prevodi prema jeziku zahtjeva.
/// <see cref="Template"/> je poruka na bosanskom (ključ prijevoda), a <see cref="Arguments"/> vrijednosti za {0}, {1}...
/// </summary>
public abstract class LocalizableException : Exception
{
    protected LocalizableException(string template, object?[] arguments, Exception? innerException = null)
        : base(Format(template, arguments), innerException)
    {
        Template = template;
        Arguments = arguments;
    }

    public string Template { get; }

    public object?[] Arguments { get; }

    private static string Format(string template, object?[] arguments) =>
        arguments.Length == 0 ? template : string.Format(CultureInfo.InvariantCulture, template, arguments);
}
