import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../../widgets/favorite_button.dart';
import '../../widgets/rating_badge.dart';
import 'explore_item.dart';

class ExploreCard extends StatelessWidget {
  const ExploreCard({
    super.key,
    required this.item,
    required this.rating,
    required this.onTap,
  });

  final ExploreItem item;
  final ReviewSummaryItem? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cta = AppColors.cta(context);
    final bookable = item.type != ItemType.place;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  item.imageUrl == null
                      ? Container(
                          color: item.type.color.withValues(alpha: 0.12),
                          child: Icon(item.type.icon, size: 48, color: item.type.color),
                        )
                      : AuthImage(url: item.imageUrl!),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(type: item.type, id: item.id, filled: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 19),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: RatingBadge(
                          average: rating?.averageRating,
                          count: rating?.reviewCount ?? 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  if (item.extra != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.extra!,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (item.priceLabel != null)
                        Expanded(
                          child: Text(
                            item.priceLabel!,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        )
                      else
                        const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: cta),
                        onPressed: onTap,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(bookable ? 'Rezerviši' : 'Pogledaj'),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ],
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
