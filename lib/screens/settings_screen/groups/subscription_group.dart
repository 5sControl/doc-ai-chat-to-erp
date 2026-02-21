import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/bloc/offers/offers_event.dart';
import 'package:summify/constants.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';
import 'package:summify/screens/settings_screen/redeem_gift_code_dialog.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

List<ButtonItem> buildSubscriptionGroupItems(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  void onPressSubscription() {
    context.read<OffersBloc>().add(NextScreenEvent());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionScreenLimit(
          triggerScreen: 'Settings',
          fromSettings: true,
        ),
      ),
    );
  }

  void onPressSubscription1() {
    context.read<OffersBloc>().add(NextScreenEvent());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BundleScreen(
          triggerScreen: 'Settings',
          fromSettings: true,
        ),
      ),
    );
  }

  void onPressChrome() {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      bounce: false,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) => const ExtensionModal(),
    );
    context.read<MixpanelBloc>().add(const OpenSummifyExtensionModal());
  }

  void onPressFeedback() {
    Navigator.of(context).pushNamed('/request');
  }

  Future<void> onPressRateApp() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  return [
    if (!kIsFreeApp) ...[
      ButtonItem(
        title: 'App Bundle',
        leadingIcon: Assets.icons.present,
        onTap: onPressSubscription1,
        trailing: Container(
          width: 90,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromRGBO(90, 255, 245, 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: const Text(
            'New',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      ButtonItem(
        title: 'Subscription',
        leadingIcon: Assets.icons.crown,
        onTap: onPressSubscription,
        trailing: Container(
          width: 90,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 238, 90, 1),
                Color.fromRGBO(255, 208, 74, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: const Text(
            'Upgrade',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
    ButtonItem(
      title: l10n.giftCode_menuTitle,
      leadingIcon: Assets.icons.present,
      onTap: () => showRedeemGiftCodeDialog(context: context),
    ),
    ButtonItem(
      title: 'Add Summify for Chrome',
      leadingIcon: Assets.icons.chromeMini,
      onTap: onPressChrome,
      trailing: Container(
        width: 90,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(255, 238, 90, 1),
              Color.fromRGBO(255, 208, 74, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: const Text(
          'Free',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
    ButtonItem(
      title: 'Request a feature',
      leadingIcon: Assets.icons.chat,
      onTap: onPressFeedback,
    ),
    if (!kIsWeb && Platform.isIOS)
      ButtonItem(
        title: 'Rate Summify',
        leadingIcon: Assets.icons.star,
        onTap: onPressRateApp,
      ),
  ];
}
