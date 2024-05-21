import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';

import '../../services/summaryApi.dart';

const Map<String, String> translateLanguages = {
  "ru": 'Russian',
  "fr": "French",
  "ar": "Arabic",
  "uk": "Ukrainian",
  "es": "Spanish",
  "zh": "Chinese"
};

Future<void> translateDialog(
    {required BuildContext context,
    required String summaryKey,
    required String text}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return DialogState(
        summaryKey: summaryKey,
        text: text,
      );
    },
  );
}

class DialogState extends StatefulWidget {
  final String summaryKey;
  final String text;
  const DialogState({super.key, required this.text, required this.summaryKey});

  @override
  State<DialogState> createState() => _DialogStateState();
}

class _DialogStateState extends State<DialogState> {
  String selectedLang = translateLanguages.keys.first;

  void onSelectLang({required String lang}) {
    setState(() {
      selectedLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: 0,
    );

    void onPressTranslate() async {

      // context.read<SummariesBloc>().add(TranslateSummary(
      //     summaryKey: widget.summaryKey,
      //     summaryText: widget.text,
      //     languageCode: selectedLang));
      Navigator.of(context).pop();
    }

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      insetPadding: const EdgeInsets.only(bottom: 100),
      alignment: Alignment.bottomCenter,
      backgroundColor: Theme.of(context).canvasColor,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 10),
      titlePadding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      title: Text(
        'Select translate language',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      content:
          LanguagesDropDown(controller: controller, onSelectLang: onSelectLang),
      actions: <Widget>[
        MaterialButton(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 70),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          onPressed: onPressTranslate,
          child: const Text('Translate'),
        ),
      ],
    );
  }
}

class LanguagesDropDown extends StatelessWidget {
  final FixedExtentScrollController controller;
  final Function({required String lang}) onSelectLang;
  const LanguagesDropDown(
      {super.key, required this.controller, required this.onSelectLang});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CupertinoPicker(
          scrollController: controller,
          diameterRatio: 1,
          magnification: 1.2,
          squeeze: 1.6,
          useMagnifier: true,
          itemExtent: 25,
          onSelectedItemChanged: (int selectedItem) {
            onSelectLang(lang: translateLanguages.keys.toList()[selectedItem]);
          },
          children: translateLanguages.keys
              .map((e) => Center(
                    child: Text(
                      translateLanguages[e]!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ))
              .toList()),
    );
  }
}
