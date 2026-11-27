import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../layout/admin_section.dart';
import '../../widgets/equal_height_grid.dart';
import '../../widgets/error_view.dart';
import '../../widgets/reservation_status_chip.dart';
import 'revenue_chart.dart';
import 'status_breakdown.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onOpen});

  /// Otvara drugu sekciju administracije.
  final ValueChanged<AdminSection> onOpen;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardData {
  _DashboardData(this.summary, this.recent);

  final DashboardResponse summary;
  final List<Reservation> recent;
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<_DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardData> _load() async {
    final api = context.read<ApiClient>();
    final results = await Future.wait([
      ReportService(api).getDashboard(),
      ReservationService(api).getPage(ReservationSearch(), pageSize: 5),
    ]);

    return _DashboardData(
      results[0] as DashboardResponse,
      (results[1] as PageResult<Reservation>).items,
    );
  }

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorView(message: snapshot.error.toString(), onRetry: _refresh);
        }

        return _DashboardContent(
          data: snapshot.data!,
          onRefresh: _refresh,
          onOpen: widget.onOpen,
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.onRefresh, required this.onOpen});

  final _DashboardData data;
  final VoidCallback onRefresh;
  final ValueChanged<AdminSection> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = data.summary;
    final firstName = context.watch<AuthProvider>().session?.firstName ?? '';
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? tr.goodMorning(firstName)
        : (now.hour < 18 ? tr.goodAfternoon(firstName) : tr.goodEvening(firstName));
    final narrow = MediaQuery.sizeOf(context).width < 900;

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          tr.dashboardOverviewFor(Formatters.monthYear(now)),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(tr.refresh),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.cta(context),
            foregroundColor: Colors.white,
          ),
          onPressed: () => onOpen(AdminSection.reports),
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: Text(tr.exportReport),
        ),
      ],
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(narrow ? 16 : 28, 24, narrow ? 16 : 28, 28),
      children: [
        if (narrow) ...[heading, const SizedBox(height: 16), actions]
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Expanded(child: heading), actions],
          ),
        const SizedBox(height: 24),
        EqualHeightGrid(
          children: [
            _KpiCard(
              icon: Icons.payments_outlined,
              color: AppColors.success,
              title: tr.kpiRevenueThisMonth,
              value: Formatters.money(summary.revenueThisMonth),
              trend: _Trend.from(summary.revenueThisMonth, summary.revenueLastMonth),
            ),
            _KpiCard(
              icon: Icons.event_available_outlined,
              color: AppColors.room,
              title: tr.kpiReservationsThisMonth,
              value: '${summary.reservationsThisMonth}',
            ),
            _KpiCard(
              icon: Icons.pending_actions_outlined,
              color: AppColors.terracotta,
              title: tr.kpiAwaitingConfirmation,
              value: '${summary.awaitingConfirmation}',
              subtitle: tr.kpiAwaitingConfirmationHint,
              onTap: summary.awaitingConfirmation > 0 ? () => onOpen(AdminSection.reservations) : null,
            ),
            _KpiCard(
              icon: Icons.luggage_outlined,
              color: AppColors.activity,
              title: tr.kpiArrivals7Days,
              value: '${summary.upcomingArrivals}',
            ),
            _KpiCard(
              icon: Icons.star_outline,
              color: AppColors.star,
              title: tr.kpiAverageRating,
              value: summary.averageRating == null ? '–' : Formatters.decimal(summary.averageRating!),
              subtitle: tr.kpiFromReviews(summary.reviewCount),
            ),
            _KpiCard(
              icon: Icons.people_outline,
              color: AppColors.equipment,
              title: tr.kpiGuests,
              value: '${summary.guestCount}',
            ),
          ],
        ),
        const SizedBox(height: 20),
        _TwoColumns(
          height: 400,
          left: _Panel(
            title: tr.netRevenueByMonth,
            expand: true,
            child: RevenueChart(data: summary.revenueByMonth, expand: true),
          ),
          right: _Panel(
            title: tr.reservationsByStatus,
            expand: true,
            child: StatusBreakdown(data: summary.reservationsByStatus),
          ),
          narrowLeft: _Panel(
            title: tr.netRevenueByMonth,
            child: RevenueChart(data: summary.revenueByMonth),
          ),
          narrowRight: _Panel(
            title: tr.reservationsByStatus,
            child: StatusBreakdown(data: summary.reservationsByStatus),
          ),
        ),
        const SizedBox(height: 20),
        _TwoColumns(
          left: _Panel(
            title: tr.latestReservations,
            action: TextButton(
              onPressed: () => onOpen(AdminSection.reservations),
              child: Text(tr.showAll),
            ),
            child: _RecentReservations(items: data.recent),
          ),
          right: _Panel(
            title: tr.mostBookedYear,
            child: _TopItems(items: summary.topItems),
          ),
        ),
      ],
    );
  }
}

/// Dva panela jedan pored drugog (2:1), ili jedan ispod drugog na užem prozoru.
class _TwoColumns extends StatelessWidget {
  const _TwoColumns({
    required this.left,
    required this.right,
    this.height,
    this.narrowLeft,
    this.narrowRight,
  });

  final Widget left;
  final Widget right;
  final double? height;
  final Widget? narrowLeft;
  final Widget? narrowRight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1100) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [narrowLeft ?? left, const SizedBox(height: 16), narrowRight ?? right],
          );
        }

        final row = Row(
          crossAxisAlignment: height == null ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2, child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );

        return height == null ? row : SizedBox(height: height, child: row);
      },
    );
  }
}

class _Trend {
  _Trend(this.percent);

  final double percent;

  static _Trend? from(double current, double previous) =>
      previous <= 0 ? null : _Trend((current - previous) / previous * 100);
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String? subtitle;
  final _Trend? trend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final up = (trend?.percent ?? 0) >= 0;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 22, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  if (trend != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (up ? AppColors.success : AppColors.danger).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${up ? '↑' : '↓'} ${Formatters.decimal(trend!.percent.abs())} %',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: up ? AppColors.success : AppColors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(value, style: theme.textTheme.headlineMedium),
                  if (icon == Icons.star_outline && value != '–') ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, color: AppColors.star, size: 26),
                  ],
                ],
              ),
              if (subtitle != null || trend != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle ?? tr.comparedToLastMonth,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child, this.expand = false, this.action});

  final String title;
  final Widget child;
  final bool expand;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19))),
                  ?action,
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (expand) Expanded(child: child) else child,
          ],
        ),
      ),
    );
  }
}

class _RecentReservations extends StatelessWidget {
  const _RecentReservations({required this.items});

  final List<Reservation> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final api = context.read<ApiClient>();

    if (items.isEmpty) {
      return Text(tr.noReservationsYet);
    }

    final narrow = MediaQuery.sizeOf(context).width < 1000;

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                _Thumb(
                  type: items[i].itemType,
                  url: itemImageUrl(api, items[i].itemType, _itemId(items[i]) ?? 0,
                      coverImageId: items[i].coverImageId, hasImage: items[i].hasImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].itemName, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(items[i].userFullName, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                if (!narrow)
                  Expanded(
                    flex: 3,
                    child: Text(items[i].periodLabel, style: theme.textTheme.bodySmall),
                  ),
                SizedBox(
                  width: 110,
                  child: Text(
                    Formatters.money(items[i].totalPrice),
                    textAlign: TextAlign.right,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 110,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ReservationStatusChip(status: items[i].status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static int? _itemId(Reservation r) => r.roomId ?? r.equipmentId ?? r.activityId;
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.type, required this.url});

  final ItemType type;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forItemType(type);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 44,
        height: 44,
        child: url == null
            ? Container(color: color.withValues(alpha: 0.14), child: Icon(Icons.image_outlined, color: color))
            : AuthImage(url: url!, width: 44, height: 44),
      ),
    );
  }
}

class _TopItems extends StatelessWidget {
  const _TopItems({required this.items});

  final List<TopItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Text(tr.noReservationsYet);
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: i == 0 ? AppColors.terracottaSoft : theme.colorScheme.primaryContainer,
                  foregroundColor: i == 0 ? AppColors.terracotta : theme.colorScheme.onPrimaryContainer,
                  child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].name, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(items[i].type, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(tr.reservationsShort(items[i].reservationCount), style: theme.textTheme.labelLarge),
                    Text(Formatters.money(items[i].revenue), style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
