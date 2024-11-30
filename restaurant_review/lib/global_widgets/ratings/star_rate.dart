import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';

class StarRating extends StatelessWidget {
  final double value;
  final void Function(int)? onPressed;
  final double size;

  const StarRating({
    super.key,
    required this.value,
    this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: onPressed != null ? () => onPressed!(index + 1) : null,
          child: Icon(
            Icons.star,
            color: index < value ? AppColors.rateYellow : AppColors.rateGray,
            size: size,
          ),
        );
      }),
    );
  }
}
