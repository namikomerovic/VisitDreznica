import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../../widgets/rating_badge.dart';
import 'explore_item.dart';

class ExploreCard extends StatelessWidget {
  const ExploreCard({super.key, required this.item, required this.rating, required this.onTap});

  final ExploreItem item;
  final ReviewSummaryItem? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 116,
              height: 116,
              child: item.imageUrl == null
                  ? Container(
                      color: item.type.color.withValues(alpha: 0.12),
                      child: Icon(item.type.icon, size: 40, color: item.type.color),
                    )
                  : AuthImage(url: item.imageUrl!),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                    if (item.extra != null) ...[
                      const SizedBox(height: 2),
                      Text(item.extra!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingBadge(average: rating?.averageRating, count: rating?.reviewCount ?? 0),
                        const Spacer(),
                        if (item.priceLabel != null)
                          Text(item.priceLabel!, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}