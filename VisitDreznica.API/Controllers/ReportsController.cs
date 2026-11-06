using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Reports;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize(Roles = AppRoles.Admin)]
public class ReportsController(IReportService reportService, IReportPdfService reportPdfService) : ControllerBase
{
    [HttpGet("dashboard")]
    public Task<DashboardResponse> Dashboard() => reportService.GetDashboardAsync();

    [HttpGet("financial")]
    public Task<FinancialReportResponse> Financial([FromQuery] ReportPeriodRequest period) =>
        reportService.GetFinancialAsync(period);

    [HttpGet("occupancy")]
    public Task<OccupancyReportResponse> Occupancy([FromQuery] ReportPeriodRequest period) =>
        reportService.GetOccupancyAsync(period);

    [HttpGet("activities")]
    public Task<ActivityReportResponse> Activities([FromQuery] ReportPeriodRequest period) =>
        reportService.GetActivitiesAsync(period);
  [HttpGet("financial/pdf")]
    public async Task<IActionResult> FinancialPdf([FromQuery] ReportPeriodRequest period) =>
        Pdf(await reportPdfService.FinancialAsync(period));

    [HttpGet("occupancy/pdf")]
    public async Task<IActionResult> OccupancyPdf([FromQuery] ReportPeriodRequest period) =>
        Pdf(await reportPdfService.OccupancyAsync(period));

    [HttpGet("activities/pdf")]
    public async Task<IActionResult> ActivitiesPdf([FromQuery] ReportPeriodRequest period) =>
        Pdf(await reportPdfService.ActivitiesAsync(period));

    private FileContentResult Pdf(ReportFile file) => File(file.Content, "application/pdf", file.FileName);
}