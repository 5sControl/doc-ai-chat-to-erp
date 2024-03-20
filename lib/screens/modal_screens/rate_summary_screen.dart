import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/shared_links/shared_links_bloc.dart';

class RateSummaryScreen extends StatefulWidget {
  final String summaryLink;
  const RateSummaryScreen({super.key, required this.summaryLink});

  @override
  State<RateSummaryScreen> createState() => _RateSummaryScreenState();
}

class _RateSummaryScreenState extends State<RateSummaryScreen> {
  int selectedRate = 3;
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
      // context.read<SharedLinksBloc>().add(RateSummary(sharedLink: summaryLink));
      Navigator.of(context).pop();
    }

    void onPressSubmit() {
      context
          .read<SharedLinksBloc>()
          .add(RateSummary(sharedLink: widget.summaryLink));
      Navigator.of(context).pop();
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: onPressClose,
                        style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.all(2)),
                            backgroundColor: MaterialStatePropertyAll(
                                const Color.fromRGBO(4, 49, 57, 1)
                                    .withOpacity(0.1))),
                        highlightColor:
                            const Color.fromRGBO(4, 49, 57, 1).withOpacity(0.2),
                        icon: const Icon(
                          Icons.close,
                          color: Color.fromRGBO(4, 49, 57, 1),
                        )),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      'It will help us to improve quality \n of the summaries',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )),
                ),
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
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressSubmit;
  const SubmitButton({super.key, required this.onPressSubmit});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
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

  void onTap() {
    Future.delayed(duration, () {
      widget.onPressSubmit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            onTapUp: (_) => onTapUp(),
            onTapDown: (_) => onTapDown(),
            onTapCancel: () => onTapUp(),
            child: AnimatedScale(
              duration: duration,
              scale: tapped ? 0.95 : 1,
              child: AnimatedContainer(
                duration: duration,
                margin: const EdgeInsets.only(bottom: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tapped
                        ? const Color.fromRGBO(49, 210, 206, 1)
                        : const Color.fromRGBO(4, 49, 57, 1)),
                child: const Text(
                  'Submit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        )
      ],
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
                    secondChild: const Icon(
                      Icons.star_outline_rounded,
                      color: Colors.black54,
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
          textAlignVertical: TextAlignVertical.top,
          controller: controller,
          onChanged: (text) {
            controller.text = text;
          },
          cursorWidth: 3,
          cursorColor: Colors.black54,
          cursorHeight: 20,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    width: 2,
                    color: Color.fromRGBO(4, 49, 57, 1)), //<-- SEE HERE
              ),
              filled: true,
              fillColor: Colors.teal.withOpacity(0.2),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              label: const Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Text(
                  'Enter your feedback',
                  style: TextStyle(),
                ),
              ),
              border: OutlineInputBorder(
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ));
  }
}
