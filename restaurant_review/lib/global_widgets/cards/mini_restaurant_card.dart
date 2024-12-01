import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/address.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/address_lookup.dart';

class RestaurantCard extends StatelessWidget {
  final int restaurantId;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final String street;
  final String provinceId;
  final String districtId;
  final String wardId;

  const RestaurantCard({
    super.key,
    required this.restaurantId,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.street,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address?>(
      future: getAddressName(provinceId, districtId, wardId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.restaurantPage,
                arguments: {'restaurantId': restaurantId});
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
                  child: CachedNetworkImage(
                    imageUrl: baseImageUrl + imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          StarRating(value: rateAverage),
                          const SizedBox(width: 8),
                          Text(
                            '$rateAverage/5.0',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      snapshot.data == null
                          ? const SizedBox()
                          : Text(
                              '$street, ${snapshot.data!.toString()}',
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
      },
    );
  }
}
