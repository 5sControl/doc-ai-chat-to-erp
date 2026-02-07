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
        //indicatorColor: Color.fromRGBO(0, 186, 195, 1),
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
            color: Color.fromRGBO(0, 186, 195, 1),
            borderRadius: BorderRadius.circular(6)),
        tabs: [
          const Tab(
            text: "Source",
          ),
          const Tab(
            text: "Brief",
          ),
          const Tab(text: "Deep"),
          const Tab(text: "Chat"),
          const Tab(text: "Quiz"),
          const Tab(text: "Cards"),
        ],
      ),
    );
  }
}
