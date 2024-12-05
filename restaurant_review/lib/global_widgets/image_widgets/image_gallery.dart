import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/image_widgets/full_image_view.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_grid.dart';

class ImageGallery extends StatelessWidget {
  final List<String> urls;
  final double imageSize;

  const ImageGallery({
    super.key,
    required this.urls,
    this.imageSize = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return urls.isEmpty
        ? const SizedBox()
        : LayoutBuilder(
            builder: (context, constraints) {
              // Use constraints.maxWidth to get the width of the Card or parent widget
              double cardWidth = constraints.maxWidth;
              int maxImages = (cardWidth / (imageSize + 5))
                  .floor(); // Adjusting based on the parent width

              return SizedBox(
                height: imageSize,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: urls.length > maxImages ? maxImages : urls.length,
                  itemBuilder: (context, index) {
                    // Show "+X" on the last image if there are more images
                    if (index == maxImages - 1 && urls.length > maxImages) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => FullImageGrid(urls: urls));
                        },
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          color: AppColors.shadowGray,
                          alignment: Alignment.center,
                          child: Text(
                            '+${urls.length - (maxImages - 1)}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => FullImageView(url: urls[index]));
                          },
                          child: Hero(
                            tag: 'imageHero_$index',
                            child: CachedNetworkImage(
                              memCacheHeight: imageSize.toInt(),
                              memCacheWidth: imageSize.toInt(),
                              imageUrl: baseImageUrl + urls[index],
                              fit: BoxFit.cover,
                              height: imageSize,
                              width: imageSize,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: AppColors.errorRed),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    );
                  },
                ),
              );
            },
          );
  }
}
