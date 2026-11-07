import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/star_rating.dart';
import 'review_sheet.dart';

class ReviewsSection extends StatefulWidget {
  const ReviewsSection({super.key, required this.type, required this.itemId});

  final ItemType type;
  final int itemId;

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  static const _pageSize = 5;

  late final ReviewService _service;
  ReviewSummary? _summary;
  List<Review> _reviews = [];
  PageResult<Review>? _lastPage;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = ReviewService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final summary = await _service.getSummary(widget.type, widget.itemId);
      final page = await _service.getPage(itemType: widget.type, itemId: widget.itemId, pageSize: _pageSize);

      if (!mounted) return;
      setState(() {
        _summary = summary;
        _reviews = page.items;
        _lastPage = page;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final last = _lastPage;
    if (last == null || !last.hasNext || _loadingMore) return;

    setState(() => _loadingMore = true);

    try {
      final page = await _service.getPage(
        itemType: widget.type,
        itemId: widget.itemId,
        page: last.page + 1,
        pageSize: _pageSize,
      );

      if (!mounted) return;
      setState(() {
        _reviews = [..._reviews, ...page.items];
        _lastPage = page;
      });
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _write([Review? existing]) async {
    final saved = await showReviewSheet(context, type: widget.type, itemId: widget.itemId, existing: existing);

    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existing == null ? 'Hvala na recenziji!' : 'Recenzija je izmijenjena.')),
      );
      _load();
    }
  }

  Future<void> _delete(Review review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Obrisati recenziju?'),
        content: const Text('Ova radnja se ne može poništiti.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Obriši')),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _service.delete(review.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recenzija je obrisana.')));
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recenzije', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        if (_loading && summary == null)
          const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
        else if (_error != null && summary == null)
          Row(
            children: [
              Expanded(child: Text(_error!)),
              TextButton(onPressed: _load, child: const Text('Pokušaj ponovo')),
            ],
          )
        else if (summary != null) ...[
          _SummaryView(summary: summary),
          const SizedBox(height: 16),
          _buildMyReview(summary),
          const SizedBox(height: 8),
          ..._buildList(summary),
        ],
      ],
    );
  }

  Widget _buildMyReview(ReviewSummary summary) {
    final theme = Theme.of(context);
    final mine = summary.myReview;

    if (mine != null) {
      return Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Vaša recenzija', style: theme.textTheme.titleSmall),
                  const SizedBox(width: 8),
                  StarRating(rating: mine.rating.toDouble(), size: 16),
                  const Spacer(),
                  IconButton(tooltip: 'Uredi', onPressed: () => _write(mine), icon: const Icon(Icons.edit_outlined)),
                  IconButton(tooltip: 'Obriši', onPressed: () => _delete(mine), icon: const Icon(Icons.delete_outline)),
                ],
              ),
              if (mine.comment != null && mine.comment!.isNotEmpty)
                Padding(padding: const EdgeInsets.only(right: 12), child: Text(mine.comment!)),
            ],
          ),
        ),
      );
    }

    if (summary.canReview) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.tonalIcon(
          onPressed: () => _write(),
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text('Napiši recenziju'),
        ),
      );
    }

    return Text(
      'Recenziju možete ostaviti nakon završene rezervacije.',
      style: theme.textTheme.bodySmall,
    );
  }

  List<Widget> _buildList(ReviewSummary summary) {
    final others = _reviews.where((x) => x.id != summary.myReview?.id).toList();

    return [
      for (var i = 0; i < others.length; i++) ...[
        if (i > 0) const Divider(height: 1),
        _ReviewTile(review: others[i]),
      ],
      if (_lastPage?.hasNext ?? false)
        Center(
          child: TextButton(
            onPressed: _loadingMore ? null : _loadMore,
            child: Text(_loadingMore ? 'Učitavanje...' : 'Prikaži još recenzija'),
          ),
        ),
    ];
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.summary});

  final ReviewSummary summary;

  static String _reviewsLabel(int count) {
    final lastDigit = count % 10;
    final lastTwo = count % 100;
    final isFew = lastDigit >= 2 && lastDigit <= 4 && (lastTwo < 12 || lastTwo > 14);
    return isFew ? 'recenzije' : 'recenzija';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final average = summary.averageRating;

    if (summary.reviewCount == 0 || average == null) {
      return Text('Još nema recenzija.', style: theme.textTheme.bodyMedium);
    }

    final maxCount = summary.ratingCounts.fold<int>(0, (a, b) => a > b ? a : b);

    return Row(
      children: [
        Column(
          children: [
            Text(Formatters.decimal(average),
                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
            StarRating(rating: average),
            const SizedBox(height: 4),
            Text('${summary.reviewCount} ${_reviewsLabel(summary.reviewCount)}', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              for (var rating = 5; rating >= 1; rating--)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(width: 12, child: Text('$rating', style: theme.textTheme.bodySmall)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: maxCount == 0 ? 0 : summary.ratingCounts[rating - 1] / maxCount,
                            minHeight: 8,
                            color: const Color(0xFFF59E0B),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 24,
                        child: Text('${summary.ratingCounts[rating - 1]}',
                            textAlign: TextAlign.end, style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = review.userFullName;
    final comment = review.comment;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, child: Text(name.isEmpty ? '?' : name[0].toUpperCase())),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleSmall),
                    Text(Formatters.relative(review.createdAt), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              StarRating(rating: review.rating.toDouble(), size: 16),
            ],
          ),
          if (comment != null && comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(comment),
          ],
        ],
      ),
    );
  }
}