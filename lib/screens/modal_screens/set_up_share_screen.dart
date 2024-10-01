import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/summary_screen/info_modal/text_size_modal.dart';

import '../../widgets/backgroung_gradient.dart';

class InstructionStep {
  final String description;
  final String image;
  final String step;
  InstructionStep(
      {required this.image, required this.description, required this.step});
}

class SetUpShareScreen extends StatefulWidget {
  const SetUpShareScreen({super.key});

  @override
  State<SetUpShareScreen> createState() => _SetUpShareScreenState();
}

class _SetUpShareScreenState extends State<SetUpShareScreen> {
  @override
  void initState() {
    super.initState();

    context.read<MixpanelBloc>().add(const ShowInstructions());
  }

  @override
  Widget build(BuildContext context) {
    final List<InstructionStep> steps = Platform.isIOS
        ? [
            InstructionStep(
                step: 'Step 1',
                image: Assets.setUp.setUp1.path,
                description: 'Press "Share" button\non the website'),
            InstructionStep(
                step: 'Step 2',
                image: Assets.setUp.setUp2.path,
                description: 'Scroll through app\nlist and tap "More"'),
            InstructionStep(
                step: 'Step 3',
                image: Assets.setUp.setUp3.path,
                description: 'Tap "Edit" and scroll\ntill Summify'),
            InstructionStep(
                step: 'Step 4',
                image: Assets.setUp.setUp4.path,
                description: 'Tap "Add"'),
            InstructionStep(
                step: 'Step 5',
                image: Assets.setUp.setUp5.path,
                description: 'Return to the top\nand tap "Done"'),
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
      context.read<MixpanelBloc>().add(const CloseInstructions());
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
                  Padding(
                      padding: EdgeInsets.only(
                          right: 6.0,
                          top: MediaQuery.of(context).size.shortestSide >= 600
                              ? 30
                              : 50),
                      child: IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: onPressClose,
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0)),
                              minimumSize:
                                  MaterialStateProperty.all<Size>(Size(30, 30)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .iconTheme
                                      .color!
                                      .withOpacity(0))),
                          highlightColor: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.3),
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: Theme.of(context).iconTheme.color,
                          ))),
                  // IconButton(
                  //     visualDensity: VisualDensity.compact,
                  //     onPressed: onPressClose,
                  //     style: ButtonStyle(
                  //         padding:
                  //             const MaterialStatePropertyAll(EdgeInsets.all(0)),
                  //         backgroundColor: MaterialStatePropertyAll(
                  //             Theme.of(context)
                  //                 .iconTheme
                  //                 .color!
                  //                 .withOpacity(0.2))),
                  //     highlightColor:
                  //         Theme.of(context).iconTheme.color!.withOpacity(0.2),
                  //     icon: const Icon(
                  //       Icons.close,
                  //       color: Colors.white,
                  //     )),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Set up share button',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 32, height: 3),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the column size is minimal based on its children
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center-aligns the entire column horizontally
                        children: steps
                            .map(
                              (step) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Aligns image and text vertically
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          step.image,
                                          width:
                                              100, // Consistent width for all images
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        width:
                                            15), // Adds consistent spacing between image and text
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Aligns text to the start
                                        children: [
                                          Text(
                                            step.step,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(fontSize: 16),
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
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
