using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Reports;

public interface IReportService
{
    Task<DashboardResponse> GetDashboardAsync();
    Task<FinancialReportResponse> GetFinancialAsync(ReportPeriodRequest period);
    Task<OccupancyReportResponse> GetOccupancyAsync(ReportPeriodRequest period);
    Task<ActivityReportResponse> GetActivitiesAsync(ReportPeriodRequest period);
}