using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Activities;

public class ActivityMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Activity, ActivityResponse>()
            .Map(dest => dest.HasImage, src => src.ImageData != null)
            .Map(dest => dest.NextSlotStart,
                src => src.Slots.Where(s => s.StartTime > DateTime.UtcNow).Min(s => (DateTime?)s.StartTime));

        config.NewConfig<ActivitySlot, ActivitySlotResponse>()
    .Map(dest => dest.GuideFullName, src => src.Guide.FirstName + " " + src.Guide.LastName)
    .Map(dest => dest.BookedCount,
        src => src.Reservations
            .Where(r => r.Status == ReservationStatus.Pending || r.Status == ReservationStatus.Confirmed)
            .Sum(r => r.ParticipantCount))
    .Map(dest => dest.AvailableSpots,
        src => src.Capacity - src.Reservations
            .Where(r => r.Status == ReservationStatus.Pending || r.Status == ReservationStatus.Confirmed)
            .Sum(r => r.ParticipantCount));
    }
}