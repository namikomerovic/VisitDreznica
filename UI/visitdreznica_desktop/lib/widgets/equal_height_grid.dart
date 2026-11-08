import 'package:flutter/material.dart';

/// Mreža koja broj kolona računa iz dostupne širine,
/// a sve kartice u istom redu poravna na istu visinu.
class EqualHeightGrid extends StatelessWidget {
  const EqualHeightGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.spacing = 16,
    this.allowedColumns = const [6, 3, 2, 1],
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  /// Dozvoljeni brojevi kolona, od najvećeg ka najmanjem.
  final List<int> allowedColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = allowedColumns.firstWhere(
          (count) => (constraints.maxWidth - (count - 1) * spacing) / count >= minItemWidth,
          orElse: () => 1,
        );

        final rows = <Widget>[];

        for (var start = 0; start < children.length; start += columns) {
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i > 0) SizedBox(width: spacing),
                    Expanded(
                      child: start + i < children.length ? children[start + i] : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) SizedBox(height: spacing),
              rows[i],
            ],
          ],
        );
      },
    );
  }
}