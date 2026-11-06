using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.Services.Reports;

public class ReportService(VisitDreznicaDbContext dbContext) : IReportService
{
    private const int MaxPeriodDays = 366;
    private const int TopItemCount = 5;

    private static readonly ReservationStatus[] CountedStatuses = [ReservationStatus.Confirmed, ReservationStatus.Completed];
    private static readonly ReservationType[] Types = [ReservationType.Room, ReservationType.Equipment, ReservationType.Activity];

    private sealed record MoneyRow(DateTime At, ReservationType Type, decimal Amount);

    private sealed record Period(DateOnly From, DateOnly To, DateTime FromUtc, DateTime ToUtcExclusive)
    {
        public int Days => To.DayNumber - From.DayNumber + 1;
    }

    public async Task<DashboardResponse> GetDashboardAsync()
    {
        var now = DateTime.UtcNow;
        var monthStart = new DateTime(now.Year, now.Month, 1, 0, 0, 0, DateTimeKind.Utc);
        var lastMonthStart = monthStart.AddMonths(-1);
        var chartStart = monthStart.AddMonths(-11);
        var nextMonthStart = monthStart.AddMonths(1);

        var payments = await LoadPaymentsAsync(chartStart, nextMonthStart);
        var refunds = await LoadRefundsAsync(chartStart, nextMonthStart);

        var guestCount = await dbContext.Users
            .CountAsync(x => x.IsActive && x.UserRoles.Any(r => r.Role.Name == AppRoles.Guest));

        var awaitingConfirmation = await dbContext.Reservations
            .CountAsync(x => x.Status == ReservationStatus.Pending &&
                             x.Payments.Any(p => p.Status == PaymentStatus.Succeeded));

        var arrivalsUntil = now.AddDays(7);
        var upcomingArrivals = await dbContext.Set<RoomReservation>()
            .CountAsync(x => x.Status == ReservationStatus.Confirmed && x.StartTime >= now && x.StartTime < arrivalsUntil);

        var reviewStats = await dbContext.Reviews
            .GroupBy(_ => 1)
            .Select(g => new { Average = g.Average(x => (double)x.Rating), Count = g.Count() })
            .FirstOrDefaultAsync();

        var byStatus = await dbContext.Reservations
            .GroupBy(x => x.Status)
            .Select(g => new StatusCountResponse { Status = g.Key, Count = g.Count() })
            .ToListAsync();

        return new DashboardResponse
        {
            RevenueThisMonth = Net(payments, refunds, monthStart, nextMonthStart),
            RevenueLastMonth = Net(payments, refunds, lastMonthStart, monthStart),
            ReservationsThisMonth = await dbContext.Reservations.CountAsync(x => x.CreatedAt >= monthStart),
            AwaitingConfirmation = awaitingConfirmation,
            UpcomingArrivals = upcomingArrivals,
            AverageRating = reviewStats is null ? null : Math.Round(reviewStats.Average, 2),
            ReviewCount = reviewStats?.Count ?? 0,
            GuestCount = guestCount,
            RevenueByMonth = ByMonth(payments, refunds, chartStart, nextMonthStart),
            ReservationsByStatus = byStatus.OrderBy(x => x.Status).ToList(),
            TopItems = await LoadTopItemsAsync(now.AddYears(-1))
        };
    }

    public async Task<FinancialReportResponse> GetFinancialAsync(ReportPeriodRequest request)
    {
        var period = Resolve(request);

        var payments = await LoadPaymentsAsync(period.FromUtc, period.ToUtcExclusive);
        var refunds = await LoadRefundsAsync(period.FromUtc, period.ToUtcExclusive);

        var byType = Types.Select(type =>
        {
            var gross = payments.Where(x => x.Type == type).Sum(x => x.Amount);
            var refunded = refunds.Where(x => x.Type == type).Sum(x => x.Amount);

            return new TypeRevenueResponse
            {
                Type = ReservationText.TypeLabel(type),
                PaymentCount = payments.Count(x => x.Type == type),
                Gross = gross,
                Refunded = refunded,
                Net = gross - refunded
            };
        }).ToList();

        return new FinancialReportResponse
        {
            From = period.From,
            To = period.To,
            PaymentCount = payments.Count,
            Gross = byType.Sum(x => x.Gross),
            Refunded = byType.Sum(x => x.Refunded),
            Net = byType.Sum(x => x.Net),
            ByType = byType,
            ByMonth = ByMonth(payments, refunds, period.FromUtc, period.ToUtcExclusive)
        };
    }

    public async Task<OccupancyReportResponse> GetOccupancyAsync(ReportPeriodRequest request)
    {
        var period = Resolve(request);

        var rooms = await dbContext.Rooms.AsNoTracking()
            .OrderBy(x => x.Name)
            .Select(x => new { x.Id, x.Name })
            .ToListAsync();

        var stays = await dbContext.Set<RoomReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status) &&
                        x.StartTime < period.ToUtcExclusive &&
                        x.EndTime > period.FromUtc)
            .Select(x => new { x.RoomId, x.StartTime, x.EndTime, x.TotalPrice })
            .ToListAsync();

        var rows = rooms.Select(room =>
        {
            var roomStays = stays.Where(x => x.RoomId == room.Id).ToList();

            var booked = 0;
            decimal revenue = 0;

            foreach (var stay in roomStays)
            {
                var totalNights = Math.Max(1, NightsBetween(stay.StartTime, stay.EndTime));
                var nightsInPeriod = OverlapNights(stay.StartTime, stay.EndTime, period);

                booked += nightsInPeriod;
                revenue += stay.TotalPrice * nightsInPeriod / totalNights;
            }

            return new RoomOccupancyResponse
            {
                RoomName = room.Name,
                AvailableNights = period.Days,
                BookedNights = booked,
                OccupancyPercent = Percent(booked, period.Days),
                ReservationCount = roomStays.Count,
                AverageStayNights = roomStays.Count == 0
                    ? 0
                    : Math.Round(roomStays.Average(x => NightsBetween(x.StartTime, x.EndTime)), 1),
                Revenue = Math.Round(revenue, 2)
            };
        }).ToList();

        var totalAvailable = rows.Sum(x => x.AvailableNights);
        var totalBooked = rows.Sum(x => x.BookedNights);

        return new OccupancyReportResponse
        {
            From = period.From,
            To = period.To,
            DaysInPeriod = period.Days,
            TotalAvailableNights = totalAvailable,
            TotalBookedNights = totalBooked,
            OccupancyPercent = Percent(totalBooked, totalAvailable),
            Revenue = rows.Sum(x => x.Revenue),
            Rooms = rows
        };
    }

    public async Task<ActivityReportResponse> GetActivitiesAsync(ReportPeriodRequest request)
    {
        var period = Resolve(request);

        var slots = await dbContext.Set<ActivitySlot>().AsNoTracking()
            .Where(x => x.StartTime >= period.FromUtc && x.StartTime < period.ToUtcExclusive)
            .Select(x => new
            {
                x.ActivityId,
                x.Capacity,
                Participants = x.Reservations
                    .Where(r => CountedStatuses.Contains(r.Status))
                    .Sum(r => (int?)r.ParticipantCount) ?? 0,
                Revenue = x.Reservations
                    .Where(r => CountedStatuses.Contains(r.Status))
                    .Sum(r => (decimal?)r.TotalPrice) ?? 0
            })
            .ToListAsync();

        var activities = await dbContext.Activities.AsNoTracking()
            .OrderBy(x => x.Name)
            .Select(x => new { x.Id, x.Name })
            .ToListAsync();

        var activityRatings = await dbContext.Reviews.AsNoTracking()
            .Where(x => x.ActivityId != null)
            .GroupBy(x => x.ActivityId!.Value)
            .Select(g => new { Id = g.Key, Average = g.Average(x => (double)x.Rating), Count = g.Count() })
            .ToDictionaryAsync(x => x.Id);

        var activityRows = activities.Select(activity =>
        {
            var activitySlots = slots.Where(x => x.ActivityId == activity.Id).ToList();
            var capacity = activitySlots.Sum(x => x.Capacity);
            var participants = activitySlots.Sum(x => x.Participants);
            var rating = activityRatings.GetValueOrDefault(activity.Id);

            return new ActivityPerformanceResponse
            {
                Name = activity.Name,
                SlotCount = activitySlots.Count,
                Capacity = capacity,
                Participants = participants,
                FillPercent = Percent(participants, capacity),
                Revenue = activitySlots.Sum(x => x.Revenue),
                AverageRating = rating is null ? null : Math.Round(rating.Average, 2),
                ReviewCount = rating?.Count ?? 0
            };
        }).ToList();

        var places = await dbContext.Places.AsNoTracking()
            .OrderBy(x => x.Name)
            .Select(x => new PlaceRatingResponse
            {
                Name = x.Name,
                AverageRating = dbContext.Reviews.Where(r => r.PlaceId == x.Id).Average(r => (double?)r.Rating),
                ReviewCount = dbContext.Reviews.Count(r => r.PlaceId == x.Id),
                FavoriteCount = dbContext.Favorites.Count(f => f.PlaceId == x.Id),
                ViewCount = dbContext.ContentViews.Count(v => v.PlaceId == x.Id &&
                                                              v.ViewedAt >= period.FromUtc &&
                                                              v.ViewedAt < period.ToUtcExclusive)
            })
            .ToListAsync();

        foreach (var place in places.Where(x => x.AverageRating.HasValue))
        {
            place.AverageRating = Math.Round(place.AverageRating!.Value, 2);
        }

        return new ActivityReportResponse
        {
            From = period.From,
            To = period.To,
            Activities = activityRows,
            Places = places.OrderByDescending(x => x.AverageRating ?? 0).ThenByDescending(x => x.ReviewCount).ToList()
        };
    }

    private async Task<List<MoneyRow>> LoadPaymentsAsync(DateTime fromUtc, DateTime toUtcExclusive) =>
        await dbContext.Payments.AsNoTracking()
            .Where(x => x.PaidAt != null && x.PaidAt >= fromUtc && x.PaidAt < toUtcExclusive &&
                        (x.Status == PaymentStatus.Succeeded || x.Status == PaymentStatus.Refunded))
            .Select(x => new MoneyRow(
                x.PaidAt!.Value,
                x.Reservation is RoomReservation ? ReservationType.Room
                    : x.Reservation is EquipmentReservation ? ReservationType.Equipment
                    : ReservationType.Activity,
                x.Amount))
            .ToListAsync();

    private async Task<List<MoneyRow>> LoadRefundsAsync(DateTime fromUtc, DateTime toUtcExclusive) =>
        await dbContext.Refunds.AsNoTracking()
            .Where(x => x.CreatedAt >= fromUtc && x.CreatedAt < toUtcExclusive)
            .Select(x => new MoneyRow(
                x.CreatedAt,
                x.Payment.Reservation is RoomReservation ? ReservationType.Room
                    : x.Payment.Reservation is EquipmentReservation ? ReservationType.Equipment
                    : ReservationType.Activity,
                x.Amount))
            .ToListAsync();

    private async Task<List<TopItemResponse>> LoadTopItemsAsync(DateTime since)
    {
        var rooms = await dbContext.Set<RoomReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status) && x.StartTime >= since)
            .GroupBy(x => x.Room.Name)
            .Select(g => new { Name = g.Key, Count = g.Count(), Revenue = g.Sum(x => x.TotalPrice) })
            .ToListAsync();

        var equipment = await dbContext.Set<EquipmentReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status) && x.StartTime >= since)
            .GroupBy(x => x.Equipment.Name)
            .Select(g => new { Name = g.Key, Count = g.Count(), Revenue = g.Sum(x => x.TotalPrice) })
            .ToListAsync();

        var activities = await dbContext.Set<ActivityReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status) && x.StartTime >= since)
            .GroupBy(x => x.ActivitySlot.Activity.Name)
            .Select(g => new { Name = g.Key, Count = g.Count(), Revenue = g.Sum(x => x.TotalPrice) })
            .ToListAsync();

        return rooms.Select(x => (x.Name, x.Count, x.Revenue, Type: ReservationType.Room))
            .Concat(equipment.Select(x => (x.Name, x.Count, x.Revenue, Type: ReservationType.Equipment)))
            .Concat(activities.Select(x => (x.Name, x.Count, x.Revenue, Type: ReservationType.Activity)))
            .OrderByDescending(x => x.Count)
            .ThenByDescending(x => x.Revenue)
            .Take(TopItemCount)
            .Select(x => new TopItemResponse
            {
                Name = x.Name,
                Type = ReservationText.TypeLabel(x.Type),
                ReservationCount = x.Count,
                Revenue = x.Revenue
            })
            .ToList();
    }

    private static List<MonthlyRevenueResponse> ByMonth(
        List<MoneyRow> payments, List<MoneyRow> refunds, DateTime fromUtc, DateTime toUtcExclusive)
    {
        var result = new List<MonthlyRevenueResponse>();
        var month = new DateTime(fromUtc.Year, fromUtc.Month, 1, 0, 0, 0, DateTimeKind.Utc);

        while (month < toUtcExclusive)
        {
            var next = month.AddMonths(1);

            decimal NetFor(ReservationType type) =>
                payments.Where(x => x.Type == type && x.At >= month && x.At < next).Sum(x => x.Amount) -
                refunds.Where(x => x.Type == type && x.At >= month && x.At < next).Sum(x => x.Amount);

            var rooms = NetFor(ReservationType.Room);
            var equipment = NetFor(ReservationType.Equipment);
            var activities = NetFor(ReservationType.Activity);

            result.Add(new MonthlyRevenueResponse
            {
                Year = month.Year,
                Month = month.Month,
                Rooms = rooms,
                Equipment = equipment,
                Activities = activities,
                Total = rooms + equipment + activities
            });

            month = next;
        }

        return result;
    }

    private static decimal Net(List<MoneyRow> payments, List<MoneyRow> refunds, DateTime fromUtc, DateTime toUtcExclusive) =>
        payments.Where(x => x.At >= fromUtc && x.At < toUtcExclusive).Sum(x => x.Amount) -
        refunds.Where(x => x.At >= fromUtc && x.At < toUtcExclusive).Sum(x => x.Amount);

    private static Period Resolve(ReportPeriodRequest request)
    {
        var from = request.From!.Value;
        var to = request.To!.Value;

        if (to < from)
        {
            throw new BusinessException("Krajnji datum ne može biti prije početnog.");
        }

        if (to.DayNumber - from.DayNumber + 1 > MaxPeriodDays)
        {
            throw new BusinessException("Period izvještaja može biti najviše godinu dana.");
        }

        return new Period(
            from,
            to,
            from.ToDateTime(TimeOnly.MinValue, DateTimeKind.Utc),
            to.AddDays(1).ToDateTime(TimeOnly.MinValue, DateTimeKind.Utc));
    }

    private static int NightsBetween(DateTime startUtc, DateTime endUtc) =>
        DateOnly.FromDateTime(endUtc).DayNumber - DateOnly.FromDateTime(startUtc).DayNumber;

    private static int OverlapNights(DateTime startUtc, DateTime endUtc, Period period)
    {
        var first = Math.Max(DateOnly.FromDateTime(startUtc).DayNumber, period.From.DayNumber);
        var last = Math.Min(DateOnly.FromDateTime(endUtc).DayNumber, period.To.AddDays(1).DayNumber);

        return Math.Max(0, last - first);
    }

    private static double Percent(int part, int whole) =>
        whole == 0 ? 0 : Math.Round(part * 100.0 / whole, 1);
}