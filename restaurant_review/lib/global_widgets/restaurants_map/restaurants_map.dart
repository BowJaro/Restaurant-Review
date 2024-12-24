// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:get/get.dart';
// // import 'package:latlong2/latlong.dart';
// // import 'package:restaurant_review/global_classes/map_restaurant.dart';

// // // GetX Controller
// // class RestaurantsMapController extends GetxController {
// //   var restaurants = <MapRestaurantModel>[].obs;
// //   final mapCenter = const LatLng(10.8231, 106.6297).obs;

// //   void loadRestaurants(List<MapRestaurantModel> data) {
// //     restaurants.value = data;
// //     if (restaurants.isNotEmpty) {
// //       mapCenter.value = LatLng(
// //         restaurants.first.latitude,
// //         restaurants.first.longitude,
// //       );
// //     }
// //   }
// // }

// // class RestaurantsMap extends StatelessWidget {
// //   final RestaurantsMapController controller =
// //       Get.put(RestaurantsMapController());

// //   RestaurantsMap({Key? key, required List<MapRestaurantModel> restaurants})
// //       : super(key: key) {
// //     controller.loadRestaurants(restaurants);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Restaurants Map'),
// //       ),
// //       body: Obx(() {
// //         return FlutterMap(
// //           options: MapOptions(
// //             initialCenter: controller.mapCenter.value, // Updated parameter
// //             initialZoom: 13.0, // Updated parameter
// //           ),
// //           children: [
// //             TileLayer(
// //               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
// //               subdomains: ['a', 'b', 'c'],
// //             ),
// //             MarkerLayer(
// //               markers: controller.restaurants.map((restaurant) {
// //                 return Marker(
// //                   width: 80.0,
// //                   height: 80.0,
// //                   point: LatLng(restaurant.latitude, restaurant.longitude),
// //                   child: GestureDetector(
// //                     // Changed from builder to child
// //                     onTap: () {
// //                       Get.snackbar(
// //                         'Restaurant Selected',
// //                         restaurant.name,
// //                         snackPosition: SnackPosition.BOTTOM,
// //                       );
// //                     },
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         ClipOval(
// //                           child: Image.network(
// //                             restaurant.imageUrl,
// //                             width: 40.0,
// //                             height: 40.0,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return const Icon(Icons.restaurant);
// //                             },
// //                           ),
// //                         ),
// //                         const SizedBox(height: 4.0),
// //                         Container(
// //                           padding: const EdgeInsets.all(4.0),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(4.0),
// //                             boxShadow: const [
// //                               BoxShadow(
// //                                 color: Colors.black26,
// //                                 blurRadius: 2.0,
// //                               ),
// //                             ],
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Text(
// //                                 restaurant.name,
// //                                 style: const TextStyle(
// //                                   fontSize: 12.0,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                                 textAlign: TextAlign.center,
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                               Text(
// //                                 '⭐ ${restaurant.rateAverage.toStringAsFixed(1)}',
// //                                 style: const TextStyle(fontSize: 10.0),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ],
// //         );
// //       }),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:restaurant_review/global_classes/map_restaurant.dart';

// // GetX Controller
// class RestaurantsMapController extends GetxController {
//   var restaurants = <MapRestaurantModel>[].obs;
//   final mapCenter =
//       LatLng(10.8231, 106.6297).obs; // Default to a specific location

//   @override
//   void onInit() {
//     super.onInit();
//     _determinePosition();
//   }

//   void loadRestaurants(List<MapRestaurantModel> data) {
//     restaurants.value = data;
//     if (restaurants.isNotEmpty) {
//       mapCenter.value = LatLng(
//         restaurants.first.latitude,
//         restaurants.first.longitude,
//       );
//     }
//   }

//   Future<void> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar(
//         'Location Disabled',
//         'Please enable location services to view your current position.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     // Check location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar(
//           'Permission Denied',
//           'Location permission is required to display your current position.',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar(
//         'Permission Denied',
//         'Location permissions are permanently denied.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     // Get current position
//     Position position = await Geolocator.getCurrentPosition();
//     mapCenter.value = LatLng(position.latitude, position.longitude);
//   }
// }

// class RestaurantsMap extends StatelessWidget {
//   final RestaurantsMapController controller =
//       Get.put(RestaurantsMapController());

//   RestaurantsMap({Key? key, required List<MapRestaurantModel> restaurants})
//       : super(key: key) {
//     controller.loadRestaurants(restaurants);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Restaurants Map'),
//       ),
//       body: Obx(() {
//         return FlutterMap(
//           options: MapOptions(
//             initialCenter:
//                 controller.mapCenter.value, // Updated to dynamic location
//             initialZoom: 13.0,
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               subdomains: ['a', 'b', 'c'],
//             ),
//             MarkerLayer(
//               markers: controller.restaurants.map((restaurant) {
//                 return Marker(
//                   width: 80.0,
//                   height: 80.0,
//                   point: LatLng(restaurant.latitude, restaurant.longitude),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.snackbar(
//                         'Restaurant Selected',
//                         restaurant.name,
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ClipOval(
//                           child: Image.network(
//                             restaurant.imageUrl,
//                             width: 40.0,
//                             height: 40.0,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.restaurant);
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 4.0),
//                         Container(
//                           padding: const EdgeInsets.all(4.0),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(4.0),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 2.0,
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 restaurant.name,
//                                 style: const TextStyle(
//                                   fontSize: 12.0,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 '⭐ ${restaurant.rateAverage.toStringAsFixed(1)}',
//                                 style: const TextStyle(fontSize: 10.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/map_restaurant.dart';
import 'package:restaurant_review/routes/routes.dart';

// GetX Controller
class RestaurantsMapController extends GetxController {
  var restaurants = <MapRestaurantModel>[].obs;
  final mapCenter =
      LatLng(10.8231, 106.6297).obs; // Default to a specific location

  @override
  void onInit() async {
    super.onInit();
    await determinePosition();
  }

  void loadRestaurants(List<MapRestaurantModel> data) {
    restaurants.value = data;
    if (restaurants.isNotEmpty) {
      mapCenter.value = LatLng(
        restaurants.first.latitude,
        restaurants.first.longitude,
      );
    }
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Disabled',
        'Please enable location services to view your current position.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is required to display your current position.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    mapCenter.value = LatLng(position.latitude, position.longitude);
  }
}

class RestaurantsMap extends StatelessWidget {
  final RestaurantsMapController controller =
      Get.put(RestaurantsMapController());

  RestaurantsMap({super.key, required List<MapRestaurantModel> restaurants}) {
    controller.loadRestaurants(restaurants);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FlutterMap(
        options: MapOptions(
          initialCenter:
              controller.mapCenter.value, // Updated to dynamic location
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: controller.restaurants.map((restaurant) {
              return Marker(
                width: 120.0,
                height: 180.0,
                point: LatLng(restaurant.latitude, restaurant.longitude),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.restaurantPage,
                        arguments: {'id': restaurant.id});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: baseImageUrl +
                              restaurant
                                  .imageUrl, // Directly using the avatarUrl
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.restaurant,
                            color: AppColors.primary2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '⭐ ${restaurant.rateAverage.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
