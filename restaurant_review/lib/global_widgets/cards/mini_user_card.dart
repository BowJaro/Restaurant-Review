import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/routes/routes.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String? imageUrl;
  final String? name;
  final String? userName;
  final DateTime joinDate;
  final VoidCallback? onTap;
  const UserCard(
      {super.key,
      required this.userId,
      required this.imageUrl,
      required this.name,
      required this.userName,
      required this.joinDate,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Get.toNamed(Routes.user, arguments: {'userId': userId});
          },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.backgroundGray,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: baseImageUrl + imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.backgroundGray,
                      child: const Icon(Icons.image, color: AppColors.white),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? FlutterI18n.translate(context, "following.unknown"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName ??
                        FlutterI18n.translate(context, "following.unknown"),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${FlutterI18n.translate(context, "following.join_date")}: ${joinDate.day}/${joinDate.month}/${joinDate.year}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
