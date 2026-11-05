namespace VisitDreznica.Model.Responses;

public class FileContent
{
    public byte[] Data { get; set; } = [];
    public string ContentType { get; set; } = string.Empty;
}