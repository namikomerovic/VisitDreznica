import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';

Future<bool> showReviewSheet(
  BuildContext context, {
  required ItemType type,
  required int itemId,
  Review? existing,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReviewSheet(type: type, itemId: itemId, existing: existing),
  );
  return saved ?? false;
}

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({required this.type, required this.itemId, required this.existing});

  final ItemType type;
  final int itemId;
  final Review? existing;

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  static const _labels = ['Dodirnite zvjezdicu', 'Loše', 'Slabo', 'Dobro', 'Vrlo dobro', 'Odlično'];

  late final ReviewService _service;
  late final TextEditingController _comment;
  late int _rating;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = ReviewService(context.read<ApiClient>());
    _comment = TextEditingController(text: widget.existing?.comment ?? '');
    _rating = widget.existing?.rating ?? 0;
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_rating == 0) {
      setState(() => _error = 'Odaberite ocjenu od 1 do 5.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final text = _comment.text.trim();
    final comment = text.isEmpty ? null : text;

    try {
      final existing = widget.existing;

      if (existing == null) {
        await _service.create(widget.type, widget.itemId, rating: _rating, comment: comment);
      } else {
        await _service.update(existing.id, rating: _rating, comment: comment);
      }

      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.existing == null ? 'Nova recenzija' : 'Uredi recenziju', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 40,
                  onPressed: _saving
                      ? null
                      : () => setState(() {
                            _rating = i;
                            _error = null;
                          }),
                  icon: Icon(
                    i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
            ],
          ),
          Text(_labels[_rating], textAlign: TextAlign.center, style: theme.textTheme.titleSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _comment,
            enabled: !_saving,
            maxLines: 4,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Komentar (nije obavezan)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          if (_error != null) MessageBox(text: _error!, isError: true),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Sačuvaj'),
          ),
        ],
      ),
    );
  }
}