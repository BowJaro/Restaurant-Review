import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/view/account_view.dart';
import 'package:restaurant_review/modules/explore/view/explore_view.dart';
import 'package:restaurant_review/modules/feed/view/feed_view.dart';
import 'package:restaurant_review/modules/language/widget/language_radio_button.dart';
import 'package:restaurant_review/modules/saved/view/saved_view.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/services/supabase.dart';

import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final List<Widget> _screens = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Explore'),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.postDetail,
                  arguments: {'isNew': false, 'id': 5});
            },
            child: const Text("Go to post detail to edit"),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.postDetail, arguments: {'isNew': true});
            },
            child: const Text("Go to post detail"),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.restaurantDetail, arguments: {'isNew': true});
            },
            child: const Text("Go to add new restaurant"),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.restaurantDetail,
                  arguments: {'isNew': false, 'id': 1});
            },
            child: const Text("Go to restaurant detail"),
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.brandDetail, arguments: {'isNew': true});
              },
              child: const Text("Go to Brand Detail page to add new")),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.brandDetail,
                    arguments: {'isNew': false, 'id': 11});
              },
              child: const Text("Go to Brand Detail page to edit")),
          TextButton(
              onPressed: () async {
                await supabase.auth.signOut();
                Get.offAllNamed(Routes.splash);
              },
              child: const Text("Sign out")),
        ],
      ),
    ),
    // const Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text('Notification'),
    //       LanguageRadioButton(),
    //     ],
    //   ),
    // ),
    // const FeedView(),
    // const ExploreView(),
    // const SavedView(),
    const FeedView(),
    // const ExploreView(),
    // const SavedView(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: _screens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
                label: FlutterI18n.translate(context, "home.feed")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: FlutterI18n.translate(context, "home.explore")),
            // BottomNavigationBarItem(
            //     icon: const Icon(Icons.bookmark),
            //     label: FlutterI18n.translate(context, "home.saved")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: FlutterI18n.translate(context, "home.account")),
          ],
        ),
      );
    });
  }
}
