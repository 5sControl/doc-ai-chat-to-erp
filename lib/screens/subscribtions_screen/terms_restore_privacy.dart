import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/subscriptions/subscriptions_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TermsRestorePrivacy extends StatelessWidget {
  const TermsRestorePrivacy({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    void onPressTerms() async {
      final Uri url = Uri.parse(
          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
      if (!await launchUrl(url)) {}
    }

    void onPressRestore() async {
      context.read<SubscriptionsBloc>().add(RestoreSubscriptions(context: context));
    }

    void onPressPrivacy() async {
      final Uri url = Uri.parse('https://elang.app/privacy');
      if (!await launchUrl(url)) {}
    }

    return Row(
      children: [
        if (!kIsWeb && Platform.isIOS)
          Expanded(
            child: TextButton(
              onPressed: onPressTerms,
              
              child: Text(
                l10n.paywall_termsOfUse,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyMedium!.color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Expanded(
          child: TextButton(
            onPressed: onPressRestore,
            style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero)),
            child: Text(
              l10n.paywall_restorePurchase,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (!kIsWeb && Platform.isIOS)
          Expanded(
            child: TextButton(
              onPressed: onPressPrivacy,
              child: Text(
                l10n.paywall_privacyPolicy,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyMedium!.color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}