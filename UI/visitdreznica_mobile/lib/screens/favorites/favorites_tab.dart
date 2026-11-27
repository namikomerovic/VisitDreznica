import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../providers/favorites_provider.dart';
import '../../widgets/favorite_button.dart';
import '../../widgets/item_thumbnail.dart';
import '../details/item_navigation.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favorites = context.watch<FavoritesProvider>();
    final items = favorites.items;

    if (favorites.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favorites.error != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(favorites.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: favorites.load, child: Text(tr.retry)),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: favorites.load,
      child: items.isEmpty
          ? ListView(
              children: [
                const SizedBox(height: 120),
                Icon(Icons.favorite_outline, size: 56, color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                Center(child: Text(tr.noFavoritesYet)),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    tr.favoritesHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final favorite = items[index];
                final type = favorite.itemType;

                return ListTile(
                  leading: ItemThumbnail(
                    type: type,
                    url: itemImageUrl(
                      context.read<ApiClient>(),
                      type,
                      favorite.itemId,
                      coverImageId: favorite.coverImageId,
                      hasImage: favorite.hasImage,
                    ),
                  ),
                  title: Text(favorite.itemName),
                  subtitle: Text(tr.savedOn(type.label, Formatters.date(favorite.createdAt))),
                  trailing: FavoriteButton(type: type, id: favorite.itemId),
                  onTap: () => openItemDetails(context, type, favorite.itemId),
                );
              },
            ),
    );
  }
}