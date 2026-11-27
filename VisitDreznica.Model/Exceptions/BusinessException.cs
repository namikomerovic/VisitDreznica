namespace VisitDreznica.Model.Exceptions;

public class BusinessException : LocalizableException
{
    public BusinessException(string template, params object?[] arguments) : base(template, arguments) { }

    public BusinessException(string template, Exception innerException) : base(template, [], innerException) { }
}
