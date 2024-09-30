import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/summary_screen/info_modal/text_size_modal.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width:MediaQuery.of(context).size.shortestSide <
                                            600 ? MediaQuery.of(context).size.width : 343,
        padding: const EdgeInsets.only(top: 5, bottom: 5,), // Add padding if needed
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Theme.of(context).brightness == Brightness.dark
                  ? Assets.bgDark.path
                  : Assets.bgLight.path),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover),
          //color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              right: 5.0,
              child: BackArrow(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Select Language',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      ),
                ),
                //const SizedBox(height: 20),
                LanguagesDropDown(
                    controller: controller, onSelectLang: onSelectLang),
                const SizedBox(height: 10),
                Center(
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onPressConfirm,
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
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
      height: 130,
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
