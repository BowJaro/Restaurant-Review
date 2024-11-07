import 'package:flutter/material.dart';
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
      title: Text(title),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonLabel,
            style: const TextStyle(
              fontSize: AppFontSizes.s7,
              fontWeight: FontWeight.bold,
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
