import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.type, required this.id, this.filled = false});

  final ItemType type;
  final int id;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(type, id);
    final busy = favorites.isBusy(type, id);

    return IconButton(
      tooltip: isFavorite ? 'Ukloni iz favorita' : 'Dodaj u favorite',
      style: filled
          ? IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85))
          : null,
      onPressed: busy ? null : () => _toggle(context, favorites, isFavorite),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
    );
  }

  Future<void> _toggle(BuildContext context, FavoritesProvider favorites, bool wasFavorite) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await favorites.toggle(type, id);
      messenger.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(wasFavorite ? 'Uklonjeno iz favorita.' : 'Dodano u favorite.'),
      ));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}