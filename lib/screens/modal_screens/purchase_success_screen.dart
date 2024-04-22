import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_animations/animation_builder/mirror_animation_builder.dart';

import '../../gen/assets.gen.dart';

class PurchaseSuccessScreen extends StatelessWidget {
  const PurchaseSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Thank's for your subscription"  ,
                      style:
                      TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  MirrorAnimationBuilder(
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: SvgPicture.asset(
                          Assets.icons.headrt,
                          height: 100,
                          width: 100,
                        ),
                      );
                    },
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 1, end: 1.2),
                    curve: Curves.easeIn,
                  ),
                  const ContinueButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContinueButton extends StatefulWidget {
  // final StoreProduct? product;
  const ContinueButton({super.key});

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  bool tapped = false;

  static const duration = Duration(milliseconds: 150);
  void onTapDown() {
    setState(() {
      tapped = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        tapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onPressContinue() {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

    }

    return GestureDetector(
        onTap: onPressContinue,
        onTapUp: (_) => onTapUp(),
        onTapDown: (_) => onTapDown(),
        onTapCancel: () => onTapUp(),
        child: AnimatedScale(
          duration: duration,
          scale: tapped ? 0.95 : 1,
          child: AnimatedContainer(
            width: double.infinity,
            duration: duration,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: !tapped
                  ? const Color.fromRGBO(31, 188, 183, 1)
                  : const Color.fromRGBO(4, 49, 57, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
