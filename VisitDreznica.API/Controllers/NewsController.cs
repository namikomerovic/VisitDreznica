using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.NewsItems;

namespace VisitDreznica.API.Controllers;

public class NewsController(INewsService service, IEntityImageService<News> imageService)
    : ImageCrudController<News, NewsResponse, NewsSearchObject, NewsUpsertRequest, NewsUpsertRequest>(service, imageService);