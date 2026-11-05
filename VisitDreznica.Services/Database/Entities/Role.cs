namespace VisitDreznica.Services.Database.Entities;

public class Role : LookupEntity
{
    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}