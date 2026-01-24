import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';

const Map<String, String> uiLanguages = {
  "system": "System",
  "en": "English",
  "ru": "Русский",
  "pl": "Polski",
  "de": "Deutsch",
  "fr": "Français",
  "es": "Español",
  "pt": "Português",
  "it": "Italiano",
  "vi": "Tiếng Việt",
  "zh-CN": "中文(简体)",
  "tr": "Türkçe",
};

Future<void> interfaceLanguageDialog({
  required BuildContext context,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const _InterfaceLanguageDialog();
    },
  );
}

class _InterfaceLanguageDialog extends StatefulWidget {
  const _InterfaceLanguageDialog();

  @override
  State<_InterfaceLanguageDialog> createState() => _InterfaceLanguageDialogState();
}

class _InterfaceLanguageDialogState extends State<_InterfaceLanguageDialog> {
  late String selectedCode;

  @override
  void initState() {
    super.initState();
    selectedCode = context.read<SettingsBloc>().state.uiLocaleCode;
    if (!uiLanguages.containsKey(selectedCode)) {
      selectedCode = 'system';
    }
  }

  void onSelectLang({required String code}) {
    setState(() {
      selectedCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = FixedExtentScrollController(
      initialItem: uiLanguages.keys.toList().indexOf(selectedCode).clamp(0, uiLanguages.length - 1),
    );

    void onPressConfirm() {
      context.read<SettingsBloc>().add(SetUiLocale(uiLocaleCode: selectedCode));
      Navigator.of(context).pop();
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.shortestSide < 600
            ? MediaQuery.of(context).size.width
            : 343,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              right: 5.0,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 18),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.settings_selectLanguageTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                _LanguagesDropDown(
                  controller: controller,
                  onSelectLang: onSelectLang,
                ),
                const SizedBox(height: 10),
                Center(
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: onPressConfirm,
                    child: Text(
                      l10n.common_select,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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

class _LanguagesDropDown extends StatelessWidget {
  final FixedExtentScrollController controller;
  final Function({required String code}) onSelectLang;
  const _LanguagesDropDown({
    required this.controller,
    required this.onSelectLang,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CupertinoPicker(
        scrollController: controller,
        diameterRatio: 1,
        magnification: 1.2,
        squeeze: 1.6,
        useMagnifier: true,
        itemExtent: 28,
        onSelectedItemChanged: (int selectedItem) {
          onSelectLang(code: uiLanguages.keys.toList()[selectedItem]);
        },
        children: uiLanguages.keys
            .map(
              (e) => Center(
                child: Text(
                  uiLanguages[e]!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

