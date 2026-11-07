import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover});

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget placeholder(Widget child) => Container(
          width: width,
          height: height,
          color: scheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: child,
        );

    return Image.network(
      url,
      headers: context.read<ApiClient>().authHeaders,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => placeholder(Icon(Icons.broken_image_outlined, color: scheme.outline)),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : placeholder(const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
    );
  }
}