import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      padding: const EdgeInsets.all(1.5),
      height: 68,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TabBar(
        controller: tabController,
        // isScrollable: true,
        labelColor: Colors.white,
        automaticIndicatorColorAdjustment: false,
        mouseCursor: null,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
        indicator: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(6)),
        tabs: const [
          Tab(
            text: "Brief",
          ),
          Tab(text: "Deep"),
          Tab(text: "Chat"),
        ],
      ),
    );
  }
}
