import 'package:flutter/material.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
