import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/error_view.dart';
import 'revenue_chart.dart';
import 'status_breakdown.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<DashboardResponse> _load() => ReportService(context.read<ApiClient>()).getDashboard();

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardResponse>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorView(message: snapshot.error.toString(), onRetry: _refresh);
        }

        return _DashboardContent(data: snapshot.data!, onRefresh: _refresh);
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.onRefresh});

  final DashboardResponse data;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Text('Pregled poslovanja', style: theme.textTheme.titleMedium),
            const Spacer(),
            IconButton(tooltip: 'Osvježi', onPressed: onRefresh, icon: const Icon(Icons.refresh)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _KpiCard(
              icon: Icons.payments_outlined,
              title: 'Prihod ovog mjeseca',
              value: Formatters.money(data.revenueThisMonth),
              subtitle: _revenueTrend(data.revenueThisMonth, data.revenueLastMonth),
            ),
            _KpiCard(
              icon: Icons.event_available_outlined,
              title: 'Rezervacije ovog mjeseca',
              value: '${data.reservationsThisMonth}',
            ),
            _KpiCard(
              icon: Icons.pending_actions_outlined,
              title: 'Čeka potvrdu',
              value: '${data.awaitingConfirmation}',
              subtitle: 'Plaćene, čekaju vašu potvrdu',
              highlight: data.awaitingConfirmation > 0,
            ),
            _KpiCard(
              icon: Icons.luggage_outlined,
              title: 'Dolasci (7 dana)',
              value: '${data.upcomingArrivals}',
            ),
            _KpiCard(
              icon: Icons.star_outline,
              title: 'Prosječna ocjena',
              value: data.averageRating == null ? '–' : '${Formatters.decimal(data.averageRating!)} ★',
              subtitle: 'Iz ${data.reviewCount} recenzija',
            ),
            _KpiCard(
              icon: Icons.people_outline,
              title: 'Gosti',
              value: '${data.guestCount}',
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final revenue = _Panel(
              title: 'Neto prihod po mjesecima',
              child: RevenueChart(data: data.revenueByMonth),
            );
            final statuses = _Panel(
              title: 'Rezervacije po statusu',
              child: StatusBreakdown(data: data.reservationsByStatus),
            );

            if (constraints.maxWidth < 1100) {
              return Column(children: [revenue, const SizedBox(height: 16), statuses]);
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: revenue),
                const SizedBox(width: 16),
                Expanded(child: statuses),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _Panel(title: 'Najtraženije u zadnjih godinu dana', child: _TopItems(items: data.topItems)),
      ],
    );
  }

  static String _revenueTrend(double current, double previous) {
    if (previous <= 0) {
      return 'Prošli mjesec: ${Formatters.money(previous)}';
    }

    final change = (current - previous) / previous * 100;
    final sign = change >= 0 ? '+' : '−';
    return '$sign${Formatters.decimal(change.abs())} % u odnosu na prošli mjesec';
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: 250,
      child: Card(
        color: highlight ? scheme.tertiaryContainer : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: 12),
              Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _TopItems extends StatelessWidget {
  const _TopItems({required this.items});

  final List<TopItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Još nema rezervacija.');
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(radius: 16, child: Text('${i + 1}')),
            title: Text(items[i].name),
            subtitle: Text(items[i].type),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${items[i].reservationCount} rezervacija'),
                Text(Formatters.money(items[i].revenue), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}