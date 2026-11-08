import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star_rounded
                : rating >= i - 0.5
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: size,
            color: AppColors.star,
          ),
      ],
    );
  }
}