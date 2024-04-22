import 'package:flutter/material.dart';
import 'package:status_bar_control/status_bar_control.dart';

import 'package:summify/screens/home_screen/home_screen.dart';

import '../widgets/add_summary_button.dart';
import '../widgets/backgroung_gradient.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // void setSystemColor() async {
  //   print(MediaQuery.of(context).platformBrightness);
  //   // Theme.of(context).brightness == Brightness.dark
  //   //     ? await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT)
  //   //     : await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
  // }
  //
  // @override
  // void initState() {
  //   setSystemColor();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).platformBrightness);

    return Stack(children: [
      const BackgroundGradient(),
      Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: const HomeScreen(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10),
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
