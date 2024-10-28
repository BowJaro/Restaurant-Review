import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/image_widgets/full_image_view.dart';

class ImageCarouselController extends GetxController {
  var currentIndex = 0.obs;
  final carouselController = CarouselSliderController();

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void changePage(int index) {
    carouselController.jumpToPage(index);
  }
}

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final ImageCarouselController controller = Get.put(ImageCarouselController());

  ImageCarousel({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller.carouselController,
          itemCount: imageUrls.length,
          itemBuilder: (context, index, realIdx) {
            return GestureDetector(
              onTap: () {
                Get.to(() => FullImageView(url: imageUrls[index]));
              },
              child: Hero(
                tag: 'imageHero_$index',
                child: Image.network(
                  imageUrls[index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.errorRed,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 250,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              controller.updateIndex(index);
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final url = imageUrls[index];
              return GestureDetector(
                onTap: () {
                  controller.changePage(index);
                },
                child: Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.currentIndex.value == index
                            ? Colors.red
                            : Colors.transparent,
                      ),
                    ),
                    child: Image.network(
                      url,
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
