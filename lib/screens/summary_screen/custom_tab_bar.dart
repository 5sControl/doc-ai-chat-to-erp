import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      padding: const EdgeInsets.all(1.5),
      height: 68,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: Colors.white,
        automaticIndicatorColorAdjustment: false,
        mouseCursor: null,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        enableFeedback: false,
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        unselectedLabelColor: colorScheme.onSurface,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 1,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.fill,
        indicator: BoxDecoration(
            color: primary, borderRadius: BorderRadius.circular(6)),
        tabs: const [
          Tab(
            text: "Source",
          ),
          Tab(
            text: "Brief",
          ),
          Tab(text: "Deep"),
          Tab(text: "Chat"),
          Tab(text: "Quiz"),
          Tab(text: "Cards"),
        ],
      ),
    );
  }
}
