import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/cards/mini_post_card.dart';

import '../controller/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterI18n.translate(context, "user.title")),
            centerTitle: true,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.userModel.name ??
              FlutterI18n.translate(context, "user.no_name")),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    controller.userModel.avatarUrl != null
                        ? CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(
                                baseImageUrl + controller.userModel.avatarUrl!),
                          )
                        : const CircleAvatar(
                            radius: 75,
                            child: Icon(
                              Icons.person,
                              size: 75,
                            ),
                          ),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          controller.toggleFollowing();
                        },
                        child: controller.userModel.isFollowed.value == true
                            ? const Icon(
                                Icons.favorite,
                                color: AppColors.primary,
                                size: 25,
                              )
                            : const Icon(Icons.favorite_border, size: 25),
                      );
                    }),
                  ],
                ),
              ),
              controller.userModel.biography != ""
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(controller.userModel.biography),
                      ],
                    )
                  : const SizedBox(),
              controller.postList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          FlutterI18n.translate(context, "user.post_list"),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 15),
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.postList.length,
                  itemBuilder: (context, index) {
                    final item = controller.postList[index].value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MiniPostCard(
                        id: item.id,
                        name: item.name,
                        topic: item.topic,
                        subtitle:
                            item.createdAt.toIso8601String().split('T')[0],
                        imageUrl: item.imageUrl,
                        viewCount: item.viewCount,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
