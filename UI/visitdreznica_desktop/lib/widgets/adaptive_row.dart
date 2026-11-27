import 'package:flutter/material.dart';

/// Red polja u formi: na širokom prozoru jedno pored drugog, na uskom jedno ispod drugog.
/// Djeca se pišu kao za [Row] (Expanded + SizedBox(width: ...) kao razmak).
class AdaptiveRow extends StatelessWidget {
  const AdaptiveRow({
    super.key,
    required this.children,
    this.breakpoint = 560,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double breakpoint;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return Row(crossAxisAlignment: crossAxisAlignment, children: children);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final child in children)
              if (child is SizedBox && child.child == null && child.height == null)
                const SizedBox(height: 16)
              else if (child is Flexible)
                child.child
              else
                child,
          ],
        );
      },
    );
  }
}
