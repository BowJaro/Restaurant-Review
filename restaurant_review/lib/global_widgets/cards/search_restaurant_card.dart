import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/address.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/address_lookup.dart';

class SearchRestaurantCard extends StatelessWidget {
  final int restaurantId;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final String street;
  final String provinceId;
  final String districtId;
  final String wardId;
  final double? distance;
  final double? imageWidth;
  final double? imageHeight;
  final double marginRight;
  final double marginLeft;
  final double marginBottom;

  const SearchRestaurantCard({
    super.key,
    required this.restaurantId,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.street,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    this.distance,
    this.imageWidth,
    this.imageHeight,
    this.marginRight = 2.0,
    this.marginLeft = 8.0,
    this.marginBottom = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address?>(
      future: getAddressName(provinceId, districtId, wardId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.restaurantPage, arguments: {'id': restaurantId});
          },
          child: Container(
            margin: EdgeInsets.only(
                bottom: marginBottom, right: marginRight, left: marginLeft),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: baseImageUrl + imageUrl,
                    width: imageWidth ??
                        (Get.width * 2 / 3 -
                            10), // Default value if width is null
                    height:
                        imageHeight ?? 140, // Default value if height is null
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8), // Space between image and text

                // Text Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: (imageWidth ?? (Get.width * 2 / 3 - 10)) -
                            16), // Set max width here
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Restaurant Name with max width
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  (imageWidth ?? (Get.width * 2 / 3 - 26)) -
                                      80), // Set max width here
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Rating
                        if (rateAverage > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.yellow[800]!,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.yellow[100]!,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '$rateAverage',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 224, 150, 30),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Address Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: snapshot.data == null
                      ? const SizedBox()
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: Get.width * 2 / 3 -
                                22, // Same width as the image
                          ),
                          child: Text(
                            '$street, ${snapshot.data!.toString()}',
                            style: const TextStyle(
                              fontSize: 10,
                              overflow: TextOverflow
                                  .ellipsis, // Truncate with ellipsis
                            ),
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                ),

                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
