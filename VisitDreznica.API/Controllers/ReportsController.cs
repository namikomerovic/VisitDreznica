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
public class ReportsController(IReportService reportService) : ControllerBase
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
}