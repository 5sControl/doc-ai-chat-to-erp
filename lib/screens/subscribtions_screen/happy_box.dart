import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import '../../gen/assets.gen.dart';

class HappyBox extends StatelessWidget {
  const HappyBox({super.key});

  @override
  Widget build(BuildContext context) {
    const dur = Duration(milliseconds: 200);
    const w = 120.0;
    const h = 120.0;

    return Stack(
      children: [
        Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 40,
                right: 20,
                child: SvgPicture.asset(
                  Assets.happyBox,
                  width: w,
                  height: h,
                ))
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(begin: 0, end: 10, duration: dur)
            .moveY(begin: 0, end: -10, duration: dur, delay: dur),
        Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 40,
                right: 20,
                child: SvgPicture.asset(
                  Assets.happyBoxLeftHand,
                  width: w,
                  height: h,
                ))
            .animate(
              delay: const Duration(milliseconds: 150),
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(begin: 0, end: 10, duration: dur)
            .rotate(
                begin: 0.1,
                end: 0.0,
                alignment: const Alignment(0.1, 0.1),
                duration: dur)
            .moveY(begin: 0, end: -10, duration: dur, delay: dur)
            .rotate(
                begin: 0,
                end: 0.1,
                alignment: const Alignment(0.1, 0.1),
                delay: dur,
                duration: dur),
        Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 40,
                right: 20,
                child: SvgPicture.asset(
                  Assets.happyBoxRightHand,
                  width: w,
                  height: h,
                ))
            .animate(
              delay: const Duration(milliseconds: 10),
              onPlay: (controller) => controller.repeat(),
            )
            .moveY(begin: 0, end: 10, duration: dur)
            .rotate(
                begin: -0.1,
                end: 0,
                alignment: const Alignment(0.1, 0.1),
                duration: dur)
            .moveY(begin: 0, end: -10, duration: dur, delay: dur)
            .rotate(
                begin: 0,
                end: -0.1,
                alignment: const Alignment(0.1, 0.1),
                delay: dur,
                duration: dur),
        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 30,
            right: 20,
            child: SvgPicture.asset(
              Assets.happyBoxFloor,
              width: w,
              height: h,
            ))
      ],
    );
  }
}
