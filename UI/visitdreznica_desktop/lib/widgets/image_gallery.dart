import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'auth_image.dart';
import 'dialogs.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({
    super.key,
    required this.images,
    required this.imageUrl,
    required this.onUpload,
    required this.onSetCover,
    required this.onDelete,
  });

  static const maxSizeBytes = 5 * 1024 * 1024;

  final List<GalleryImage> images;
  final String Function(int imageId) imageUrl;
  final Future<void> Function(Uint8List bytes, String fileName, String contentType) onUpload;
  final Future<void> Function(int imageId) onSetCover;
  final Future<void> Function(int imageId) onDelete;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String successMessage) async {
    setState(() => _busy = true);

    try {
      await action();
      if (mounted) showMessage(context, successMessage);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickAndUpload() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (file == null || !mounted) {
      return;
    }

    final bytes = await file.readAsBytes();

    if (!mounted) {
      return;
    }

    if (bytes.length > ImageGallery.maxSizeBytes) {
      showMessage(context, 'Slika može imati najviše 5 MB.', isError: true);
      return;
    }

    final contentType = file.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';

    await _run(() => widget.onUpload(bytes, file.name, contentType), 'Slika je dodana.');
  }
  Future<void> _delete(GalleryImage image) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Brisanje slike',
      message: image.isCover
          ? 'Obrisati naslovnu sliku? Sljedeća slika će automatski postati naslovna.'
          : 'Obrisati ovu sliku?',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (confirmed) {
      await _run(() => widget.onDelete(image.id), 'Slika je obrisana.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final image in widget.images)
          SizedBox(
            width: 180,
            height: 124,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AuthImage(url: widget.imageUrl(image.id)),
                ),
                if (image.isCover)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(8)),
                      child: Text('Naslovna', style: TextStyle(color: scheme.onPrimary, fontSize: 12)),
                    ),
                  ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Material(
                    color: Colors.black45,
                    shape: const CircleBorder(),
                    child: PopupMenuButton<String>(
                      enabled: !_busy,
                      tooltip: 'Opcije slike',
                      iconColor: Colors.white,
                      onSelected: (value) => value == 'cover'
                          ? _run(() => widget.onSetCover(image.id), 'Naslovna slika je promijenjena.')
                          : _delete(image),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'cover',
                          enabled: !image.isCover,
                          child: const Text('Postavi kao naslovnu'),
                        ),
                        const PopupMenuItem(value: 'delete', child: Text('Obriši')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          width: 180,
          height: 124,
          child: OutlinedButton(
            onPressed: _busy ? null : _pickAndUpload,
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: _busy
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.add_photo_alternate_outlined), SizedBox(height: 6), Text('Dodaj sliku')],
                  ),
          ),
        ),
      ],
    );
  }
}