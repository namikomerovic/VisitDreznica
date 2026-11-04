using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Services.Database.Entities
{
    public class City : IEntity
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? PostalCode { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;
    }
}
