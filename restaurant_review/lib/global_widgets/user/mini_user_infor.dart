import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

class MiniUserInfor extends StatelessWidget {
  final String profileId;
  final String username;
  final String avatarUrl;
  final void Function(String) goToUserDetail;

  const MiniUserInfor({
    super.key,
    required this.profileId,
    required this.username,
    required this.avatarUrl,
    required this.goToUserDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("This is profileId $profileId");
        goToUserDetail(profileId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, right: 2.0, left: 8.0),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                // memCacheHeight: 70,
                // memCacheWidth: 70,
                imageUrl:
                    baseImageUrl + avatarUrl, // Directly using the avatarUrl
                fit: BoxFit.cover,
                height: 70,
                width: 70,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: AppColors.errorRed,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              username,
              style: const TextStyle(fontSize: 12, color: AppColors.textBlack1),
            ),
          ],
        ),
      ),
    );
  }
}
