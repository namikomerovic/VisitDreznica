using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Services.Database.Entities
{
    public class Country
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;

        public ICollection<City> Cities { get; set; } = new List<City>();
    }
}
