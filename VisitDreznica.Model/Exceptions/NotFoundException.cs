namespace VisitDreznica.Model.Exceptions;

public class NotFoundException(string template, params object?[] arguments) : LocalizableException(template, arguments);
