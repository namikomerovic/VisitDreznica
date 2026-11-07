import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.average, required this.count});

  final double? average;
  final int count;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;

    if (average == null || count == 0) {
      return Text('Još nema ocjena', style: style);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
        const SizedBox(width: 2),
        Text(Formatters.decimal(average!), style: style?.copyWith(fontWeight: FontWeight.w600)),
        Text(' ($count)', style: style),
      ],
    );
  }
}