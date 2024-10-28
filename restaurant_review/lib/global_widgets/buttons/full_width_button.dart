import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/font_sizes.dart';

class FullWidthButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const FullWidthButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shadowColor: AppColors.shadowGray,
        elevation: 5,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppFontSizes.s6,
        ),
      ),
    );
  }
}
