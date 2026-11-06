using VisitDreznica.Model.Requests;

namespace VisitDreznica.Services.Interactions;

public interface IContentViewService
{
    Task RecordAsync(ItemReferenceRequest item);
}