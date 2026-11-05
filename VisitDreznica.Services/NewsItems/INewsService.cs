using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.NewsItems;

public interface INewsService : ICrudService<NewsResponse, NewsSearchObject, NewsUpsertRequest, NewsUpsertRequest>;