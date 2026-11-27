import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../../widgets/favorite_button.dart';
import '../details/item_navigation.dart';
import 'news_details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onOpenCategory, required this.onOpenExplore});

  final ValueChanged<ItemType> onOpenCategory;
  final VoidCallback onOpenExplore;

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
    final scheme = theme.colorScheme;
    final firstName = context.watch<AuthProvider>().session?.firstName ?? '';

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Zdravo, $firstName', style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text('Udahni Drežnicu.', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 16, color: AppColors.cta(context)),
                    const SizedBox(width: 4),
                    Text('Drežnica, Bosna i Hercegovina', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SearchEntry(onTap: widget.onOpenExplore),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _HeroCard(onExplore: widget.onOpenExplore),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final type in ItemType.values)
                  Expanded(child: _CategoryButton(type: type, onTap: () => widget.onOpenCategory(type))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<Recommendation>>(
            future: _recommendationsFuture,
            builder: (context, snapshot) => _RecommendationsSection(snapshot: snapshot),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Novosti', style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 10),
          FutureBuilder<PageResult<NewsItem>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
              }

              final items = snapshot.data?.items ?? const <NewsItem>[];

              if (items.isEmpty) {
                return const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Trenutno nema novosti.'));
              }

              return Column(
                children: [for (final item in items) _NewsCard(item: item, service: _news)],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search, color: scheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pretraži smještaj, opremu, aktivnosti…',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/hero.jpg', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x11000000), Color(0xCC0F1F17)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Malo mjesto.\nVeliki doživljaji.',
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, height: 1.15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rijeka, kanjon i planina na dohvat ruke.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.terracotta,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: onExplore,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Istraži ponudu'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({required this.type, required this.onTap});

  final ItemType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, color: type.color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              type.pluralLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Flexible(
                child: Text(personalized ? 'Preporučeno za vas' : 'Popularno među gostima',
                    style: theme.textTheme.titleLarge),
              ),
              const SizedBox(width: 6),
              Icon(personalized ? Icons.auto_awesome : Icons.local_fire_department_outlined,
                  color: AppColors.cta(context), size: 20),
            ],
          ),
        ),
        if (!personalized)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            child: Text(
              'Ocijenite ili sačuvajte ono što vam se sviđa, pa ćemo vam preporučivati po vašem ukusu.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
    final url = itemImageUrl(context.read<ApiClient>(), type, item.itemId,
        coverImageId: item.coverImageId, hasImage: item.hasImage);

    return SizedBox(
      width: 190,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openItemDetails(context, type, item.itemId),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    url == null
                        ? Container(
                            color: type.color.withValues(alpha: 0.14),
                            child: Icon(type.icon, color: type.color, size: 40),
                          )
                        : AuthImage(url: url),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: FavoriteButton(type: type, id: item.itemId, filled: true),
                    ),
                    Positioned(left: 8, bottom: 8, child: _TypeLabel(type: type)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.itemName, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          item.reason,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeLabel extends StatelessWidget {
  const _TypeLabel({required this.type});

  final ItemType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: type.color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item, required this.service});

  final NewsItem item;
  final NewsService service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => NewsDetailsScreen(item: item)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 88,
              height: 76,
              child: item.hasImage
                  ? AuthImage(url: service.imageUrl(item.id))
                  : Container(
                      color: scheme.primaryContainer,
                      child: Icon(Icons.campaign_outlined, color: scheme.onPrimaryContainer),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(Formatters.date(item.publishedAt), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.chevron_right)),
          ],
        ),
      ),
    );
  }
}
