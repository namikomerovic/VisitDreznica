using System.Globalization;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using VisitDreznica.Model.Requests;
using VisitDreznica.Services.Payments;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.Services.Reports;

public class ReportPdfService(IReportService reportService, PaymentSettings paymentSettings) : IReportPdfService
{
    private static readonly string[] MonthNames =
    [
        "Januar", "Februar", "Mart", "April", "Maj", "Juni",
        "Juli", "August", "Septembar", "Oktobar", "Novembar", "Decembar"
    ];

    private sealed record TableColumn(string Header, float Width);

    public async Task<ReportFile> FinancialAsync(ReportPeriodRequest period)
    {
        var report = await reportService.GetFinancialAsync(period);

        var pdf = Build("Finansijski izvještaj", report.From, report.To, column =>
        {
            Summary(column,
                ("Broj uplata", report.PaymentCount.ToString(CultureInfo.InvariantCulture)),
                ("Uplaćeno", Money(report.Gross)),
                ("Vraćeno gostima", Money(report.Refunded)),
                ("Neto prihod", Money(report.Net)));

            Section(column, "Prihod po vrsti");
            DataTable(column,
                [new("Vrsta", 3), new("Uplata", 1.2f), new("Uplaćeno", 2), new("Vraćeno", 2), new("Neto", 2)],
                report.ByType.Select(x => new[]
                {
                    x.Type, x.PaymentCount.ToString(CultureInfo.InvariantCulture),
                    Money(x.Gross), Money(x.Refunded), Money(x.Net)
                }),
                ["Ukupno", report.PaymentCount.ToString(CultureInfo.InvariantCulture),
                    Money(report.Gross), Money(report.Refunded), Money(report.Net)]);

            Section(column, "Neto prihod po mjesecima");
            DataTable(column,
                [new("Mjesec", 2.5f), new("Smještaj", 2), new("Oprema", 2), new("Aktivnosti", 2), new("Ukupno", 2)],
                report.ByMonth.Select(x => new[]
                {
                    $"{MonthNames[x.Month - 1]} {x.Year}",
                    Money(x.Rooms), Money(x.Equipment), Money(x.Activities), Money(x.Total)
                }),
                ["Ukupno",
                    Money(report.ByMonth.Sum(x => x.Rooms)), Money(report.ByMonth.Sum(x => x.Equipment)),
                    Money(report.ByMonth.Sum(x => x.Activities)), Money(report.ByMonth.Sum(x => x.Total))]);

            Note(column, "Prihod je iskazan po datumu uplate, a povrati po datumu povrata novca.");
        });

        return new ReportFile(pdf, FileName("finansijski-izvjestaj", report.From, report.To));
    }

    public async Task<ReportFile> OccupancyAsync(ReportPeriodRequest period)
    {
        var report = await reportService.GetOccupancyAsync(period);

        var pdf = Build("Zauzetost smještaja", report.From, report.To, column =>
        {
            Summary(column,
                ("Dana u periodu", report.DaysInPeriod.ToString(CultureInfo.InvariantCulture)),
                ("Zauzete noći", $"{report.TotalBookedNights} / {report.TotalAvailableNights}"),
                ("Popunjenost", Percent(report.OccupancyPercent)),
                ("Prihod od smještaja", Money(report.Revenue)));

            Section(column, "Po sobama");
            DataTable(column,
                [
                    new("Soba", 4), new("Rezerv.", 1.3f), new("Zauzeto", 1.3f), new("Moguće", 1.3f),
                    new("Popunjenost", 1.7f), new("Prosj. boravak", 1.8f), new("Prihod", 2)
                ],
                report.Rooms.Select(x => new[]
                {
                    x.RoomName,
                    x.ReservationCount.ToString(CultureInfo.InvariantCulture),
                    x.BookedNights.ToString(CultureInfo.InvariantCulture),
                    x.AvailableNights.ToString(CultureInfo.InvariantCulture),
                    Percent(x.OccupancyPercent),
                    $"{Number(x.AverageStayNights, "0.0")} noći",
                    Money(x.Revenue)
                }),
                ["Ukupno",
                    report.Rooms.Sum(x => x.ReservationCount).ToString(CultureInfo.InvariantCulture),
                    report.TotalBookedNights.ToString(CultureInfo.InvariantCulture),
                    report.TotalAvailableNights.ToString(CultureInfo.InvariantCulture),
                    Percent(report.OccupancyPercent), "", Money(report.Revenue)]);

            Note(column, "Računaju se samo potvrđene i završene rezervacije. Boravak koji djelimično ulazi u period " +
                         "računa se samo s noćima unutar perioda, a prihod srazmjerno broju tih noći.");
        });

        return new ReportFile(pdf, FileName("zauzetost-smjestaja", report.From, report.To));
    }

    public async Task<ReportFile> ActivitiesAsync(ReportPeriodRequest period)
    {
        var report = await reportService.GetActivitiesAsync(period);

        var pdf = Build("Aktivnosti i ocjene", report.From, report.To, column =>
        {
            Summary(column,
                ("Održanih termina", report.Activities.Sum(x => x.SlotCount).ToString(CultureInfo.InvariantCulture)),
                ("Učesnika", report.Activities.Sum(x => x.Participants).ToString(CultureInfo.InvariantCulture)),
                ("Prihod od aktivnosti", Money(report.Activities.Sum(x => x.Revenue))));

            Section(column, "Aktivnosti");
            DataTable(column,
                [
                    new("Aktivnost", 4), new("Termina", 1.3f), new("Kapacitet", 1.4f), new("Učesnika", 1.4f),
                    new("Popunjenost", 1.7f), new("Prihod", 2), new("Ocjena", 1.5f)
                ],
                report.Activities.Select(x => new[]
                {
                    x.Name,
                    x.SlotCount.ToString(CultureInfo.InvariantCulture),
                    x.Capacity.ToString(CultureInfo.InvariantCulture),
                    x.Participants.ToString(CultureInfo.InvariantCulture),
                    Percent(x.FillPercent),
                    Money(x.Revenue),
                    Rating(x.AverageRating, x.ReviewCount)
                }));

            Section(column, "Mjesta (plaže, priroda, znamenitosti)");
            DataTable(column,
                [new("Mjesto", 4), new("Ocjena", 1.8f), new("Favorita", 1.5f), new("Pregleda u periodu", 2.2f)],
                report.Places.Select(x => new[]
                {
                    x.Name,
                    Rating(x.AverageRating, x.ReviewCount),
                    x.FavoriteCount.ToString(CultureInfo.InvariantCulture),
                    x.ViewCount.ToString(CultureInfo.InvariantCulture)
                }));

            Note(column, "Termini, učesnici i prihod odnose se na odabrani period. Ocjene i favoriti " +
                         "su ukupni (od početka rada aplikacije); broj u zagradi je broj recenzija.");
        });

        return new ReportFile(pdf, FileName("aktivnosti-i-ocjene", report.From, report.To));
    }

    private static byte[] Build(string title, DateOnly from, DateOnly to, Action<ColumnDescriptor> content) =>
        Document.Create(document => document.Page(page =>
        {
            page.Size(PageSizes.A4);
            page.Margin(36);
            page.DefaultTextStyle(x => x.FontSize(9.5f).FontColor(Colors.Grey.Darken4));

            page.Header().Column(header =>
            {
                header.Item().Text("Visit Drežnica").FontSize(11).SemiBold().FontColor(Colors.Teal.Darken3);
                header.Item().Text(title).FontSize(20).Bold();
                header.Item().Text($"Period: {FormatDate(from)} – {FormatDate(to)}").FontColor(Colors.Grey.Darken1);
                header.Item().PaddingTop(6).LineHorizontal(1).LineColor(Colors.Teal.Darken3);
            });

            page.Content().PaddingVertical(14).Column(column =>
            {
                column.Spacing(10);
                content(column);
            });

            page.Footer().Row(row =>
            {
                row.RelativeItem()
                    .Text($"Generisano: {ReservationText.FormatLocal(DateTime.UtcNow)}")
                    .FontSize(8).FontColor(Colors.Grey.Medium);

                row.RelativeItem().AlignRight().Text(text =>
                {
                    text.DefaultTextStyle(x => x.FontSize(8).FontColor(Colors.Grey.Medium));
                    text.Span("Stranica ");
                    text.CurrentPageNumber();
                    text.Span(" od ");
                    text.TotalPages();
                });
            });
        })).GeneratePdf();

    private static void Summary(ColumnDescriptor column, params (string Label, string Value)[] items)
    {
        column.Item().Row(row =>
        {
            row.Spacing(8);

            foreach (var (label, value) in items)
            {
                row.RelativeItem()
                    .Border(1).BorderColor(Colors.Grey.Lighten2)
                    .Background(Colors.Grey.Lighten5)
                    .Padding(8)
                    .Column(card =>
                    {
                        card.Item().Text(label).FontSize(8).FontColor(Colors.Grey.Darken1);
                        card.Item().Text(value).FontSize(13).SemiBold();
                    });
            }
        });
    }

    private static void Section(ColumnDescriptor column, string title) =>
        column.Item().PaddingTop(6).Text(title).FontSize(12).SemiBold().FontColor(Colors.Teal.Darken3);

    private static void Note(ColumnDescriptor column, string text) =>
        column.Item().PaddingTop(4).Text(text).FontSize(8).Italic().FontColor(Colors.Grey.Darken1);

    private static void DataTable(
        ColumnDescriptor column,
        IReadOnlyList<TableColumn> columns,
        IEnumerable<string[]> rows,
        string[]? footer = null)
    {
        column.Item().Table(table =>
        {
            table.ColumnsDefinition(definition =>
            {
                foreach (var tableColumn in columns)
                {
                    definition.RelativeColumn(tableColumn.Width);
                }
            });

            table.Header(header =>
            {
                for (var i = 0; i < columns.Count; i++)
                {
                    var alignRight = i > 0;
                    header.Cell().Element(HeaderCell).Element(c => alignRight ? c.AlignRight() : c)
                        .Text(columns[i].Header).SemiBold();
                }
            });

            var hasRows = false;

            foreach (var row in rows)
            {
                hasRows = true;

                for (var i = 0; i < row.Length; i++)
                {
                    var alignRight = i > 0;
                    table.Cell().Element(BodyCell).Element(c => alignRight ? c.AlignRight() : c).Text(row[i]);
                }
            }

            if (!hasRows)
            {
                table.Cell().ColumnSpan((uint)columns.Count).Element(BodyCell)
                    .Text("Nema podataka za odabrani period.").Italic().FontColor(Colors.Grey.Darken1);
            }

            if (footer is null)
            {
                return;
            }

            for (var i = 0; i < footer.Length; i++)
            {
                var alignRight = i > 0;
                table.Cell().Element(FooterCell).Element(c => alignRight ? c.AlignRight() : c)
                    .Text(footer[i]).SemiBold();
            }
        });
    }

    private static IContainer HeaderCell(IContainer container) =>
        container.Background(Colors.Grey.Lighten3).PaddingVertical(5).PaddingHorizontal(4);

    private static IContainer BodyCell(IContainer container) =>
        container.BorderBottom(0.5f).BorderColor(Colors.Grey.Lighten2).PaddingVertical(4).PaddingHorizontal(4);

    private static IContainer FooterCell(IContainer container) =>
        container.BorderTop(1).BorderColor(Colors.Grey.Darken1).PaddingVertical(5).PaddingHorizontal(4);

    private string Money(decimal amount) => ReservationText.FormatMoney(amount, paymentSettings.Currency);

    private static string Percent(double value) => $"{Number(value, "0.0")} %";

    private static string Rating(double? average, int count) =>
        average.HasValue ? $"{Number(average.Value, "0.00")} ({count})" : "–";

    private static string Number(double value, string format) =>
        value.ToString(format, CultureInfo.InvariantCulture).Replace('.', ',');

    private static string FormatDate(DateOnly date) => date.ToString("dd.MM.yyyy.", CultureInfo.InvariantCulture);

    private static string FileName(string prefix, DateOnly from, DateOnly to) =>
        $"{prefix}_{from.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}_{to.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}.pdf";
}