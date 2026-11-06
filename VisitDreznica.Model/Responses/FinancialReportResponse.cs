namespace VisitDreznica.Model.Responses;

public class FinancialReportResponse
{
    public DateOnly From { get; set; }
    public DateOnly To { get; set; }
    public int PaymentCount { get; set; }
    public decimal Gross { get; set; }
    public decimal Refunded { get; set; }
    public decimal Net { get; set; }
    public List<TypeRevenueResponse> ByType { get; set; } = [];
    public List<MonthlyRevenueResponse> ByMonth { get; set; } = [];
}

public class TypeRevenueResponse
{
    public string Type { get; set; } = string.Empty;
    public int PaymentCount { get; set; }
    public decimal Gross { get; set; }
    public decimal Refunded { get; set; }
    public decimal Net { get; set; }
}