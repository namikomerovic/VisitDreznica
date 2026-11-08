import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

   @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/logo.png',
      package: 'visitdreznica_core',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: 'Visit Drežnica',
    );

    if (Theme.of(context).brightness == Brightness.light) {
      return image;
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: image,
    );
  }
}