import 'package:flutter/material.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: TabBar(
          padding: EdgeInsets.zero,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).textTheme.bodySmall!.color!)),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 17, fontWeight: FontWeight.w400),
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 17, fontWeight: FontWeight.w600),
          labelColor: Theme.of(context).textTheme.bodySmall!.color,
          unselectedLabelColor:
              Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.7),
          tabs: const [
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}
