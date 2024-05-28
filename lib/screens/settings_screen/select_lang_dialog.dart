import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';

const Map<String, String> translateLanguages = {
  "ar": "Arabic",
  "zh-cn": "Chinese (Simplified)",
  "zh-tw": "Chinese (Traditional)",
  "cs": "Czech",
  "nl": "Dutch",
  "en": "English",
  "fr": "French",
  "de": "German",
  "el": "Greek",
  "he": "Hebrew",
  "hi": "Hindi",
  "id": "Indonesian",
  "it": "Italian",
  "ja": "Japanese",
  "ko": "Korean",
  "fa": "Persian",
  "pl": "Polish",
  "pt": "Portuguese",
  "ro": "Romanian",
  "ru": "Russian",
  "es": "Spanish",
  "tr": "Turkish",
  "uk": "Ukrainian",
  "vi": "Vietnamese"
};

Future<void> translateDialog({
  required BuildContext context,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return DialogState();
    },
  );
}

class DialogState extends StatefulWidget {
  // final String summaryKey;
  // final String text;
  const DialogState({
    super.key,
  });

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

    void onPressConfirm() async {
      context
          .read<SettingsBloc>()
          .add(SetTranslateLanguage(translateLanguage: selectedLang));
      Navigator.of(context).pop();
    }

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Theme.of(context).primaryColorDark,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 10),
      titlePadding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      title: Text(
        'Select language',
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
          onPressed: onPressConfirm,
          child: const Text('Confirm'),
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
      height: 120,
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
