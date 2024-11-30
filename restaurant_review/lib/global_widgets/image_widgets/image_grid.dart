import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/image_widgets/full_image_view.dart';

class FullImageGrid extends StatelessWidget {
  final List<String> urls;

  const FullImageGrid({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          final String fullUrl = urls[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => FullImageView(url: fullUrl));
            },
            child: Hero(
              tag: 'imageHero_$index',
              child: CachedNetworkImage(
                imageUrl: fullUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: AppColors.errorRed),
              ),
            ),
          );
        },
      ),
    );
  }
}
