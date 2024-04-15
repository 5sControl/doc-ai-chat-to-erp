import 'dart:ui';

import 'package:flutter/material.dart';

Widget customTabBar({required TabController tabController}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    padding: const EdgeInsets.all(1.5),
    height: 52,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: TabBar(
      controller: tabController,
      // isScrollable: true,
      labelColor: Colors.white,
      automaticIndicatorColorAdjustment: false,
      mouseCursor: null,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      enableFeedback: false,
      padding: EdgeInsets.zero,
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: Colors.black,
      dividerColor: Colors.transparent,
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 1,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.fill,
      tabs: const [
        Tab(
          text: "Brief",
        ),
        Tab(text: "Deep"),
      ],
    ),
  );
}
