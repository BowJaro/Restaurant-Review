import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/address.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:restaurant_review/utils/address_lookup.dart';

class BaseRestaurantCard extends StatelessWidget {
  final int restaurantId;
  final String imageUrl;
  final String name;
  final List<String> hashtagList;
  final double rateAverage;
  final String street;
  final String provinceId;
  final String districtId;
  final String wardId;
  final VoidCallback? onTap;

  const BaseRestaurantCard({
    super.key,
    required this.restaurantId,
    required this.imageUrl,
    required this.name,
    required this.hashtagList,
    required this.rateAverage,
    required this.street,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address?>(
      future: getAddressName(provinceId, districtId, wardId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors.backgroundGray,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: baseImageUrl + imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: hashtagList
                            .map((hashtag) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text('#$hashtag'),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          StarRating(value: rateAverage),
                          const SizedBox(width: 8),
                          Text(
                            '$rateAverage/5.0',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      snapshot.data == null
                          ? const SizedBox()
                          : Text(
                              '$street, ${snapshot.data!.toString()}',
                              style: const TextStyle(
                                fontSize: 14,
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

class RestaurantCard extends BaseRestaurantCard {
  final bool isFollowed;
  final VoidCallback onHeartTap;

  const RestaurantCard({
    super.key,
    required super.restaurantId,
    required super.imageUrl,
    required super.name,
    required super.hashtagList,
    required super.rateAverage,
    required super.street,
    required super.provinceId,
    required super.districtId,
    required super.wardId,
    required this.isFollowed,
    required this.onHeartTap,
  }) : super(
          onTap: null, // Pass null to override the onTap behavior
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        super.build(context),
        Positioned(
          bottom: 8,
          right: 8,
          child: InkWell(
            onTap: onHeartTap,
            child: isFollowed
                ? const Icon(Icons.favorite, color: AppColors.primary)
                : const Icon(Icons.favorite_border),
          ),
        ),
      ],
    );
  }
}

class RestaurantCardBasic extends BaseRestaurantCard {
  const RestaurantCardBasic({
    super.key,
    required super.restaurantId,
    required super.imageUrl,
    required super.name,
    required super.hashtagList,
    required super.rateAverage,
    required super.street,
    required super.provinceId,
    required super.districtId,
    required super.wardId,
    required VoidCallback super.onTap,
  });
}
