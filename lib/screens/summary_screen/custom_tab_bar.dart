import 'dart:ui';

import 'package:flutter/material.dart';

Widget customTabBar({required TabController tabController}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    height: 35,
    decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8)),
    child: TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: Colors.white,
      automaticIndicatorColorAdjustment: false,
      mouseCursor: null,
      overlayColor: const MaterialStatePropertyAll(
          Colors.transparent),
      enableFeedback: false,
      padding: EdgeInsets.zero,
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: Colors.black,
      dividerColor: Colors.transparent,
      labelPadding:
      const EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.center,
      tabs: const [
        Tab(
          text: "Brief",
        ),
        Tab(text: "Deep"),
      ],
    ),
  );
}