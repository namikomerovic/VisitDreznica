using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Model.SearchObjects;

public class BaseSearchObject
{
    public const int MaxPageSize = 100;

    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}
