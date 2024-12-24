import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/font_sizes.dart';

class DetailPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String buttonLabel;
  final VoidCallback onPressed;
  const DetailPageAppBar({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColors.white, // Set back icon color to white
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonLabel,
            style: const TextStyle(
              fontSize: AppFontSizes.s7,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
