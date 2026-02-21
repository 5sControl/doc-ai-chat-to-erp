import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/modal_screens/set_up_share_screen.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

List<ButtonItem> buildAboutGroupItems(BuildContext context) {
  Future<void> onPressOurApps() async {
    if (!kIsWeb && Platform.isIOS) {
      final Uri url = Uri.parse(
        'https://apps.apple.com/ru/developer/english-in-games/id1656052466',
      );
      if (!await launchUrl(url)) {}
    } else {
      final Uri url = Uri.parse(
        'https://play.google.com/store/apps/dev?id=8797601455128207838&hl=ru&gl=US',
      );
      if (!await launchUrl(url)) {}
    }
  }

  void onPressSetupShare() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetUpShareScreen()),
    );
  }

  Future<void> onPressShareApp() async {
    await Share.shareUri(
      Uri.parse(
        'https://apps.apple.com/us/app/ai-text-summarizer-summify/id6478384912',
      ),
    );
  }

  return [
    ButtonItem(
      title: 'Set up share button',
      leadingIcon: Assets.icons.setUp,
      onTap: onPressSetupShare,
    ),
    if (!kIsWeb && Platform.isIOS)
      ButtonItem(
        title: 'Share this app',
        leadingIcon: Assets.icons.share,
        onTap: onPressShareApp,
      ),
    ButtonItem(
      title: 'Our apps',
      leadingIcon: Assets.icons.phone,
      onTap: onPressOurApps,
    ),
  ];
}
