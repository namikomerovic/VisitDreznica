import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      package: 'visitdreznica_core',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: 'Visit Drežnica',
    );
  }
}