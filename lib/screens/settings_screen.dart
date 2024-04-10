import 'package:flutter/material.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../widgets/premium_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [PremiumBanner()],
              )),
        ),
      ],
    );
  }
}

