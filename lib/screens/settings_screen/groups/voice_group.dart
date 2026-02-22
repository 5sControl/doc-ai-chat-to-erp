import 'package:flutter/material.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:summify/screens/settings_screen/settings_screen_layout.dart';
import 'package:summify/screens/settings_screen/tts_settings_section.dart';

List<ButtonItem> buildVoiceGroupItems(BuildContext context) {
  return [
    ButtonItem(
      title: 'Voice settings',
      leadingIcon: Assets.icons.play,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreenLayout(
              title: 'Voice settings',
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: TtsSettingsSection(),
              ),
            ),
          ),
        );
      },
    ),
  ];
}
