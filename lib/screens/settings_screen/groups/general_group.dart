import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/screens/settings_screen/select_lang_dialog.dart';
import 'package:summify/screens/settings_screen/select_ui_lang_dialog.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:summify/screens/settings_screen/widgets/notifications_switch.dart';
import 'package:summify/screens/settings_screen/widgets/theme_buttons.dart';

List<ButtonItem> buildGeneralGroupItems(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  void onTapNotifications() {
    context.read<SettingsBloc>().add(const ToggleNotifications());
  }

  return [
    ButtonItem(
      title: l10n.settings_interfaceLanguage,
      leadingIcon: Assets.icons.translate,
      onTap: () => interfaceLanguageDialog(context: context),
      trailing: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final label =
              uiLanguages[state.uiLocaleCode] ?? uiLanguages['system']!;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
            ],
          );
        },
      ),
    ),
    ButtonItem(
      title: l10n.settings_translationLanguage,
      leadingIcon: Assets.icons.translate,
      onTap: () => translateDialog(context: context),
      trailing: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translateLanguages[state.translateLanguage]!
                    .replaceAll('(Simplified)', '')
                    .replaceAll('(Traditional)', ''),
                style: Theme.of(context).textTheme.bodySmall!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
            ],
          );
        },
      ),
    ),
    ButtonItem(
      title: 'Notifications',
      leadingIcon: Assets.icons.notification,
      onTap: onTapNotifications,
      trailing: const NotificationsSwitch(),
    ),
    ButtonItem(
      title: 'Dark mode',
      leadingIcon: Assets.icons.theme,
      onTap: () {},
      trailing: const ThemeButtons(),
    ),
  ];
}
