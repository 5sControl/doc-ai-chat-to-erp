import 'package:flutter/material.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
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
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: const Text('Voice settings'),
              ),
              body: const SingleChildScrollView(
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
