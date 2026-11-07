import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'dialogs.dart';
import 'image_picking.dart';

class SingleImageEditor extends StatefulWidget {
  const SingleImageEditor({
    super.key,
    required this.imageUrl,
    required this.hasImage,
    required this.onUpload,
    required this.onDelete,
    this.placeholderIcon = Icons.image_outlined,
  });

  final String imageUrl;
  final bool hasImage;
  final Future<void> Function(Uint8List bytes, String fileName, String contentType) onUpload;
  final Future<void> Function() onDelete;
  final IconData placeholderIcon;

  @override
  State<SingleImageEditor> createState() => _SingleImageEditorState();
}

class _SingleImageEditorState extends State<SingleImageEditor> {
  bool _busy = false;
  int _version = 0;

  Future<void> _run(Future<void> Function() action, String successMessage) async {
    setState(() => _busy = true);

    try {
      await action();
      await NetworkImage(widget.imageUrl).evict();

      if (!mounted) return;
      setState(() => _version++);
      showMessage(context, successMessage);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pick() async {
    final image = await pickImage(context);

    if (image != null && mounted) {
      await _run(() => widget.onUpload(image.bytes, image.fileName, image.contentType), 'Slika je sačuvana.');
    }
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Uklanjanje slike',
      message: 'Ukloniti sliku?',
      confirmLabel: 'Ukloni',
      destructive: true,
    );

    if (confirmed) {
      await _run(widget.onDelete, 'Slika je uklonjena.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 240,
            height: 160,
            child: widget.hasImage
                ? KeyedSubtree(key: ValueKey(_version), child: AuthImage(url: widget.imageUrl))
                : Container(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(widget.placeholderIcon, size: 48, color: scheme.outline),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _pick,
              icon: _busy
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.upload_outlined),
              label: Text(widget.hasImage ? 'Promijeni sliku' : 'Odaberi sliku'),
            ),
            if (widget.hasImage) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _busy ? null : _delete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Ukloni sliku'),
              ),
            ],
            const SizedBox(height: 8),
            Text('JPG ili PNG, najviše 5 MB.', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}