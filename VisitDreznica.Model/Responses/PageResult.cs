using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Model.Responses;

public class PageResult<T>
{
    public List<T> Items { get; set; } = [];
    public int TotalCount { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
}
