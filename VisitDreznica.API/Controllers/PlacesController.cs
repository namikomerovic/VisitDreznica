using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Places;

namespace VisitDreznica.API.Controllers;

public class PlacesController(IPlaceService service, IGalleryImageService<Place, PlaceImage> galleryService)
    : GalleryCrudController<Place, PlaceImage, PlaceResponse, PlaceSearchObject, PlaceUpsertRequest, PlaceUpsertRequest>(service, galleryService);