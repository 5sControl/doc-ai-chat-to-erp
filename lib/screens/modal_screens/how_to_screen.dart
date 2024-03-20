import 'dart:ui';

import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({super.key});

  @override
  State<HowToScreen> createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
  late AssetImage image;

  @override
  void initState() {
    super.initState();
    image = AssetImage(Assets.gif.howTo.path);
  }

  @override
  void dispose() {
    image.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            )));
  }
}
