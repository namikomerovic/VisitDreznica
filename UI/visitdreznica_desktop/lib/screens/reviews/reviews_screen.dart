import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/filter_bar.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/paged_table.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _tableKey = GlobalKey<PagedTableState<Review>>();
  late final ReviewService _service;

  ItemType? _itemType;
  RangeValues _ratings = const RangeValues(1, 5);
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    _service = ReviewService(context.read<ApiClient>());
  }

  void _filtersChanged() => setState(() => _queryVersion++);

  Future<void> _open(Review review) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${review.itemType.label}: ${review.itemName}'),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Stars(rating: review.rating, size: 22),
              const SizedBox(height: 8),
              Text('${review.userFullName} · ${Formatters.dateTime(review.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Text(review.comment?.isNotEmpty == true ? review.comment! : tr.noComment),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr.deleteReview, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          FilledButton(onPressed: () => Navigator.pop(context, false), child: Text(tr.close)),
        ],
      ),
    );

    if (delete != true || !mounted) return;

    final confirmed = await showConfirmDialog(
      context,
      title: tr.deletingReview,
      message: tr.deleteGuestReviewQuestion(review.userFullName),
      confirmLabel: tr.delete,
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(review.id);
      if (!mounted) return;
      showMessage(context, tr.reviewDeleted);
      _tableKey.currentState?.reload();
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilterBar(
                children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<ItemType?>(
                      initialValue: _itemType,
                      decoration: InputDecoration(labelText: tr.type, isDense: true, border: const OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: null, child: Text(tr.all)),
                        for (final type in ItemType.values) DropdownMenuItem(value: type, child: Text(type.label)),
                      ],
                      onChanged: (value) {
                        _itemType = value;
                        _filtersChanged();
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(tr.ratingRange(_ratings.start.round(), _ratings.end.round())),
                  SizedBox(
                    width: 240,
                    child: RangeSlider(
                      values: _ratings,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      labels: RangeLabels('${_ratings.start.round()}', '${_ratings.end.round()}'),
                      onChanged: (values) => setState(() => _ratings = values),
                      onChangeEnd: (_) => _filtersChanged(),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _ratings = const RangeValues(1, 2));
                      _filtersChanged();
                    },
                    icon: const Icon(Icons.report_outlined),
                    label: Text(tr.onlyBad),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Review>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  itemType: _itemType,
                  minRating: _ratings.start.round(),
                  maxRating: _ratings.end.round(),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: _open,
                emptyText: tr.noReviewsForFilters,
                columns: [
                  PagedColumn(header: tr.rating, flex: 2, cell: (r) => _Stars(rating: r.rating)),
                  PagedColumn(header: tr.type, flex: 2, cell: (r) => Text(r.itemType.label)),
                  PagedColumn(
                    header: tr.item,
                    flex: 4,
                    cell: (r) => Text(r.itemName, overflow: TextOverflow.ellipsis),
                  ),
                  PagedColumn(
                    header: tr.comment,
                    flex: 6,
                    cell: (r) => Text(
                      r.comment?.isNotEmpty == true ? r.comment! : '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PagedColumn(header: tr.guest, flex: 3, cell: (r) => Text(r.userFullName)),
                  PagedColumn(
                    header: tr.date,
                    flex: 2,
                    alignEnd: true,
                    cell: (r) => Text(Formatters.date(r.createdAt)),
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

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, this.size = 16});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(i <= rating ? Icons.star : Icons.star_border, size: size, color: AppColors.star),
      ],
    );
  }
}