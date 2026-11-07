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
        if (widget.urls.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.urls.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _page ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: i == _page ? 1 : 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}