import 'dart:ui';

import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Scaffold(
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      Assets.gif.howTo.path,
                    )),
              )),
        ),
      ),
    );
  }
}
