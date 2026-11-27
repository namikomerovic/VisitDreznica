import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key, required this.urls, required this.type});

  final List<String> urls;
  final ItemType type;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final type = widget.type;

    if (widget.urls.isEmpty) {
      return Container(
        color: type.color.withValues(alpha: 0.15),
        alignment: Alignment.center,
        child: Icon(type.icon, size: 72, color: type.color),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.urls.length,
          onPageChanged: (index) => setState(() => _page = index),
          itemBuilder: (_, index) => AuthImage(url: widget.urls[index]),
        ),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0x55000000), Color(0x00000000)],
              ),
            ),
          ),
        ),
        if (widget.urls.length > 1)
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_page + 1}/${widget.urls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}