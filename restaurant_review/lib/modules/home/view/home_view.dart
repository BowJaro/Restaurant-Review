import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/view/account_view.dart';
import 'package:restaurant_review/modules/explore/view/explore_view.dart';
import 'package:restaurant_review/modules/feed/view/feed_view.dart';
import 'package:restaurant_review/modules/following/view/following_view.dart';

import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _screens = <Widget>[
    const FeedView(),
    const ExploreView(),
    const FollowingView(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_filled),
                label: FlutterI18n.translate(context, "home.feed")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: FlutterI18n.translate(context, "home.explore")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark),
                label: FlutterI18n.translate(context, "home.saved")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: FlutterI18n.translate(context, "home.account")),
          ],
        ),
      );
    });
  }
}
