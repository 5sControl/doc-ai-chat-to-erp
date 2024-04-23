import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_animations/animation_builder/mirror_animation_builder.dart';

import '../../gen/assets.gen.dart';

class SendRequestScreen extends StatelessWidget {
  const SendRequestScreen({super.key});

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
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'We kindly appreciate\nyour request ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          height: 1.1),
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
                    tween: Tween<double>(begin: 1, end: 1.1),
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
  const ContinueButton({super.key});

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    void onPressContinue() {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: onPressContinue,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Submit',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
