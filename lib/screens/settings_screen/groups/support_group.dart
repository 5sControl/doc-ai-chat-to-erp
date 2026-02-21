import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/constants.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

List<ButtonItem> buildSupportGroupItems(BuildContext context) {
  Future<void> onPressTerms() async {
    final Uri url = Uri.parse(
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
    );
    if (!await launchUrl(url)) {}
  }

  Future<void> onPressPrivacy() async {
    final Uri url = Uri.parse('https://elang.app/privacy');
    if (!await launchUrl(url)) {}
  }

  void onPressRestore() {
    context.read<SubscriptionsBloc>().add(
          RestoreSubscriptions(context: context),
        );
  }

  return [
    if (!kIsWeb && Platform.isIOS)
      ButtonItem(
        title: 'Terms of use',
        leadingIcon: Assets.icons.terms,
        onTap: onPressTerms,
      ),
    ButtonItem(
      title: 'Privacy policy',
      leadingIcon: Assets.icons.privacy,
      onTap: onPressPrivacy,
    ),
    if (!kIsFreeApp)
      ButtonItem(
        title: 'Restore purchase',
        leadingIcon: Assets.icons.restore,
        onTap: onPressRestore,
      ),
  ];
}
