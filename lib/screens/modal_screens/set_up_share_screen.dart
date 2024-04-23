import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:summify/gen/assets.gen.dart';

import '../../widgets/backgroung_gradient.dart';

class InstructionStep {
  final String description;
  final String image;
  final String step;
  InstructionStep(
      {required this.image, required this.description, required this.step});
}

class SetUpShareScreen extends StatelessWidget {
  const SetUpShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<InstructionStep> steps = Platform.isIOS
        ? [
            InstructionStep(
                step: 'Step 1',
                image: Assets.setUp.setUp1.path,
                description: 'Press "Share" button on the website'),
            InstructionStep(
                step: 'Step 2',
                image: Assets.setUp.setUp2.path,
                description: 'Scroll through app list and tap "More"'),
            InstructionStep(
                step: 'Step 3',
                image: Assets.setUp.setUp3.path,
                description: 'Tap "Edit" and scroll till Summify'),
            InstructionStep(
                step: 'Step 4',
                image: Assets.setUp.setUp4.path,
                description: 'Tap "Add"'),
            InstructionStep(
                step: 'Step 5',
                image: Assets.setUp.setUp5.path,
                description: 'Return to the top and tap "Done"'),
          ]
        : [
            InstructionStep(
                step: 'Step 1',
                image: Assets.setUp.setUp1A.path,
                description: 'Press "Share" button on the website '),
            InstructionStep(
                step: 'Step 2',
                image: Assets.setUp.setUp2A.path,
                description: 'Hold Summify icon'),
            InstructionStep(
                step: 'Step 3',
                image: Assets.setUp.setUp3A.path,
                description: 'Tap "Pin Summify"'),
            InstructionStep(
                step: 'Step 4',
                image: Assets.setUp.setUp4A.path,
                description: 'Summify is ready "Add"'),
          ];

    void onPressClose() {
      Navigator.of(context).pop();
    }

    return Stack(
      children: [
        const BackgroundGradient(),
        Animate(
          effects: const [FadeEffect()],
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: onPressClose,
                      style: ButtonStyle(
                          padding:
                              const MaterialStatePropertyAll(EdgeInsets.all(2)),
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.white.withOpacity(0.1))),
                      highlightColor: Colors.white.withOpacity(0.2),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    'Set up share button',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 24, height: 3),
                  ),
                  Column(
                    children: steps
                        .map((step) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    step.image,
                                    width: 100,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            step.step,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(
                                            step.description,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
