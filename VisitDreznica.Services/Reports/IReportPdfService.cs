using VisitDreznica.Model.Requests;

namespace VisitDreznica.Services.Reports;

public interface IReportPdfService
{
    Task<ReportFile> FinancialAsync(ReportPeriodRequest period);
    Task<ReportFile> OccupancyAsync(ReportPeriodRequest period);
    Task<ReportFile> ActivitiesAsync(ReportPeriodRequest period);
}