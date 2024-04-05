import 'package:flutter/material.dart';

import 'package:summify/screens/home_screen.dart';

import '../widgets/add_summary_button.dart';
import '../widgets/backgroung_gradient.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const BackgroundGradient(),
      Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: const HomeScreen(),
          bottomNavigationBar: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AddSummaryButton(),
                ),
              ],
            ),
          )),
    ]);
  }
}
