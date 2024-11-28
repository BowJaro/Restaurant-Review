import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

class FullImageView extends StatelessWidget {
  final String url;

  const FullImageView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final String fullUrl = baseImageUrl + url;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.black,
      body: Center(
        child: Hero(
          tag: 'imageHero_${url.hashCode}',
          child: CachedNetworkImage(
            memCacheHeight: 600,
            memCacheWidth: 600,
            imageUrl: fullUrl,
            fit: BoxFit.contain,
            placeholder: (context, fullUrl) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, fullUrl, error) =>
                const Icon(Icons.error, color: AppColors.errorRed),
          ),
        ),
      ),
    );
  }
}
