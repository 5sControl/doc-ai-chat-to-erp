import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';

import '../../gen/assets.gen.dart';
import 'package:simple_animations/simple_animations.dart';

class RateSummaryScreen extends StatefulWidget {
  final String summaryLink;
  const RateSummaryScreen({super.key, required this.summaryLink});

  @override
  State<RateSummaryScreen> createState() => _RateSummaryScreenState();
}

class _RateSummaryScreenState extends State<RateSummaryScreen> {
  bool isRated = false;
  int selectedRate = 0;
  final TextEditingController urlController = TextEditingController();
  var controllerText = '';

  void onChangeText() {
    setState(() {
      controllerText = urlController.text;
    });
  }

  void onPressStar({required int rate}) {
    setState(() {
      selectedRate = rate;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(onChangeText);
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      context
          .read<SummariesBloc>()
          .add(SkipRateSummary(summaryUrl: widget.summaryLink));
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }

    void onPressSubmit() {
      context.read<SummariesBloc>().add(RateSummary(
          summaryUrl: widget.summaryLink,
          rate: selectedRate,
          device: Platform.isIOS ? 'Ios' : 'Android',
          comment: controllerText));
      setState(() {
        isRated = true;
      });

      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pop();
      });
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width:MediaQuery.of(context).size.shortestSide <
                                            600 ? double.infinity : 480,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            child: AnimatedCrossFade(
              firstChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BackArrow(summaryLink: widget.summaryLink,),
                    ],
                  ),
                  const Text(
                    'Please rate your summary',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'It will help us to improve quality \n of the summaries',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Stars(
                    selectedRate: selectedRate,
                    onPressStar: onPressStar,
                  ),
                  RateTextField(
                    controller: urlController,
                  ),
                  SubmitButton(onPressSubmit: onPressSubmit)
                ],
              ),
              secondChild: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'We kindly appreciate\nyour feedback ',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w500),
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
              duration: const Duration(milliseconds: 600),
              sizeCurve: Curves.easeInBack,
              secondCurve: Curves.easeIn,
              crossFadeState: isRated
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }
}

class BackArrow extends StatelessWidget {
  final bool? fromOnboarding;
  final String? summaryLink;
  const BackArrow({super.key, this.fromOnboarding, this.summaryLink});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      context
          .read<SummariesBloc>()
          .add(SkipRateSummary(summaryUrl: summaryLink!));
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all<Size>(Size(30, 30)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
        icon: Icon(
          Icons.close,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressSubmit;
  const SubmitButton({super.key, required this.onPressSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: onPressSubmit,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class Stars extends StatelessWidget {
  final int selectedRate;
  final Function({required int rate}) onPressStar;
  const Stars(
      {super.key, required this.selectedRate, required this.onPressStar});

  @override
  Widget build(BuildContext context) {
    final rates = [1, 2, 3, 4, 5];

    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rates
            .map((rate) => IconButton(
                highlightColor: Colors.transparent,
                onPressed: () => onPressStar(rate: rate),
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutBack,
                  scale: selectedRate == rate ? 1.5 : 1,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    firstChild: const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.yellow,
                      size: 40,
                    ),
                    secondChild: Icon(
                      Icons.star_outline_rounded,
                      color: Theme.of(context).cardColor.withOpacity(0.7),
                      size: 40,
                    ),
                    crossFadeState: selectedRate >= rate
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                )))
            .toList(),
      ),
    );
  }
}

class RateTextField extends StatelessWidget {
  final TextEditingController controller;
  const RateTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: controller,
          onChanged: (text) {
            controller.text = text;
          },
          cursorHeight: 20,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black),
          decoration: const InputDecoration(hintText: 'Leave your feedback'),
        ));
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressContinue() {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
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
            child: const Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
