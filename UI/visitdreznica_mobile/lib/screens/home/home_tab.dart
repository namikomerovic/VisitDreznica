import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../details/item_navigation.dart';
import 'news_details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onOpenCategory});

  final ValueChanged<ItemType> onOpenCategory;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final RecommendationService _recommendations;
  late final NewsService _news;
  late Future<List<Recommendation>> _recommendationsFuture;
  late Future<PageResult<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _recommendations = RecommendationService(api);
    _news = NewsService(api);
    _load();
  }

  void _load() {
    _recommendationsFuture = _recommendations.getForMe(take: 10);
    _newsFuture = _news.getPage(pageSize: 3);
  }

  Future<void> _refresh() async {
    setState(_load);
    await Future.wait([_recommendationsFuture, _newsFuture]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = context.watch<AuthProvider>().session?.firstName ?? '';

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Zdravo, $firstName!', style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Šta vas danas zanima u Drežnici?', style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 92,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final type in ItemType.values)
                  _CategoryTile(type: type, onTap: () => widget.onOpenCategory(type)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Recommendation>>(
            future: _recommendationsFuture,
            builder: (context, snapshot) => _RecommendationsSection(snapshot: snapshot),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Novosti', style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 8),
          FutureBuilder<PageResult<NewsItem>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
              }

              final items = snapshot.data?.items ?? const <NewsItem>[];

              if (items.isEmpty) {
                return const Padding(padding: EdgeInsets.all(16), child: Text('Trenutno nema novosti.'));
              }

              return Column(
                children: [
                  for (final item in items)
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.campaign_outlined),
                        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(Formatters.date(item.publishedAt)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => NewsDetailsScreen(item: item)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.type, required this.onTap});

  final ItemType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 88,
          decoration: BoxDecoration(
            color: type.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, color: type.color, size: 30),
              const SizedBox(height: 6),
              Text(type.pluralLabel, style: TextStyle(color: type.color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection({required this.snapshot});

  final AsyncSnapshot<List<Recommendation>> snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (snapshot.connectionState != ConnectionState.done) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }

    final items = snapshot.data ?? const <Recommendation>[];

    if (snapshot.hasError || items.isEmpty) {
      return const SizedBox.shrink();
    }

    final personalized = items.any((x) => x.isPersonalized);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(personalized ? 'Preporučeno za vas' : 'Popularno među gostima', style: theme.textTheme.titleLarge),
              const SizedBox(width: 6),
              Icon(personalized ? Icons.auto_awesome : Icons.local_fire_department_outlined,
                  color: theme.colorScheme.primary, size: 20),
            ],
          ),
        ),
        if (!personalized)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: Text(
              'Ocijenite ili sačuvajte ono što vam se sviđa, pa ćemo vam preporučivati po vašem ukusu.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          height: 196,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) => _RecommendationCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item});

  final Recommendation item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = item.itemType;

    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openItemDetails(context, type, item.itemId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64,
                width: double.infinity,
                color: type.color.withValues(alpha: 0.14),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(type.icon, color: type.color),
                    const SizedBox(width: 8),
                    Text(type.label, style: TextStyle(color: type.color, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.itemName, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 6),
                    Text(
                      item.reason,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}