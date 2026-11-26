import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../utils/item_type_ui.dart';

class ItemThumbnail extends StatelessWidget {
  const ItemThumbnail({super.key, required this.type, required this.url, this.size = 56});

  final ItemType type;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: url == null
            ? Container(
                color: type.color.withValues(alpha: 0.14),
                child: Icon(type.icon, color: type.color),
              )
            : AuthImage(url: url!, width: size, height: size),
      ),
    );
  }
}
