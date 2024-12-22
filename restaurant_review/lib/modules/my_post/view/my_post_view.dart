import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/cards/mini_post_card.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../controller/my_post_controller.dart';

class MyPostView extends GetView<MyPostController> {
  const MyPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailPageAppBar(
        title: FlutterI18n.translate(context, "my_post.my_post"),
        buttonLabel: FlutterI18n.translate(context, "my_post.add_post"),
        onPressed: () =>
            Get.toNamed(Routes.postDetail, arguments: {"isNew": true}),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.myPostList.length,
          itemBuilder: (context, index) {
            final item = controller.myPostList[index];
            return MiniPostCard(
              id: item.postId,
              name: item.name,
              imageUrl: item.imageUrl,
              subtitle: item.createdAt.toLocal().toString().split(' ')[0],
              viewCount: item.views,
              topic: item.topic,
              onTap: () {
                Get.toNamed(Routes.postDetail,
                    arguments: {"isNew": false, "id": item.postId});
              },
            );
          },
        );
      }),
    );
  }
}
