import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/subscriptions/subscriptions_bloc.dart';

class TermsRestorePrivacy extends StatelessWidget {
  const TermsRestorePrivacy({super.key});
  @override
  Widget build(BuildContext context) {
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
        if (Platform.isIOS)
          Expanded(
            child: TextButton(
              onPressed: onPressTerms,
              
              child: Text(
                'Terms of use',
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
              'Restore purchase',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (Platform.isIOS)
          Expanded(
            child: TextButton(
              onPressed: onPressPrivacy,
              child: Text(
                'Privacy policy',
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