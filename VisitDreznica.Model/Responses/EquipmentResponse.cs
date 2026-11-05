namespace VisitDreznica.Model.Responses;

public class EquipmentResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int EquipmentTypeId { get; set; }
    public string EquipmentTypeName { get; set; } = string.Empty;
    public int Capacity { get; set; }
    public int TotalQuantity { get; set; }
    public decimal FirstHourPrice { get; set; }
    public decimal AdditionalHourPrice { get; set; }
    public decimal FullDayPrice { get; set; }
    public bool IsActive { get; set; }
    public bool HasImage { get; set; }
}