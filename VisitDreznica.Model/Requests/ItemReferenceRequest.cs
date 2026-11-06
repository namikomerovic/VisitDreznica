using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Requests;

public class ItemReferenceRequest
{
    [EnumDataType(typeof(ItemType), ErrorMessage = "Nepoznata vrsta stavke.")]
    public ItemType ItemType { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite stavku.")]
    public int ItemId { get; set; }
}