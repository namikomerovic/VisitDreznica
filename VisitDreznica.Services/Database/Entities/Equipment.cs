namespace VisitDreznica.Services.Database.Entities;

public class Equipment : IHasImage
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int Capacity { get; set; }
    public int TotalQuantity { get; set; }
    public decimal FirstHourPrice { get; set; }
    public decimal AdditionalHourPrice { get; set; }
    public decimal FullDayPrice { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[]? ImageData { get; set; }
    public string? ImageContentType { get; set; }

    public int EquipmentTypeId { get; set; }
    public EquipmentType EquipmentType { get; set; } = null!;
}