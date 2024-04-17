import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/subscription_screen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/settings/settings_bloc.dart';
import 'modal_screens/how_to_screen.dart';

class ButtonItem {
  final String title;
  final String leadingIcon;
  final Widget? trailing;
  final Function onTap;
  const ButtonItem(
      {required this.title,
      required this.leadingIcon,
      required this.onTap,
      this.trailing});
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressSubscription() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const SubscriptionScreen();
        },
      );
    }

    void onPressRestore() async {
      await InAppPurchase.instance.restorePurchases();
    }

    void onPressOurApps() async {
      final Uri url = Uri.parse(
          'https://apps.apple.com/ru/developer/english-in-games/id1656052466');
      if (!await launchUrl(url)) {}
    }

    void onPressRateApp() async {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }

    void onPressFeedback() async {
      // final Email email = Email(
      //   body: '',
      //   subject: 'Hi, I want to tell you about:',
      //   recipients: ['support@englishingames.com'],
      //   isHTML: false,
      // );
      //
      // await FlutterEmailSender.send(email);
      Navigator.of(context).pushNamed('/request');
    }

    void onPressTerms() async {
      final Uri url = Uri.parse(
          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
      if (!await launchUrl(url)) {}
    }

    void onPressPrivacy() async {
      final Uri url = Uri.parse('https://elang.app/privacy');
      if (!await launchUrl(url)) {}
    }

    void onPressShareApp() async {
      await Share.shareUri(Uri.parse(
          'https://apps.apple.com/us/app/ai-text-summarizer-summify/id6478384912'));
    }

    void onPressSetupShare() {
      showMaterialModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) => const HowToScreen());
    }

    final List<ButtonItem> membershipGroup = [
      ButtonItem(
          title: 'Subscription',
          leadingIcon: Assets.icons.crown,
          onTap: onPressSubscription,
          trailing: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(254, 205, 103, 1),
                    Color.fromRGBO(251, 171, 14, 1)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: const Text(
                'Upgrade',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ))),
      ButtonItem(
        title: 'Restore purchase',
        leadingIcon: Assets.icons.restore,
        onTap: onPressRestore,
      )
    ];

    final List<ButtonItem> aboutGroup = [
      ButtonItem(
        title: 'Set up share button',
        leadingIcon: Assets.icons.play,
        onTap: onPressSetupShare,
      ),
      ButtonItem(
        title: 'Rate Summify',
        leadingIcon: Assets.icons.star,
        onTap: onPressRateApp,
      ),
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

    final List<ButtonItem> supportGroup = [
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
      ButtonItem(
        title: 'Request a feature',
        leadingIcon: Assets.icons.chat,
        onTap: onPressFeedback,
      )
    ];

    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // PremiumBanner(),
                    const GeneralGroup(),
                    ButtonsGroup(title: 'Membership', items: membershipGroup),
                    ButtonsGroup(title: 'About', items: aboutGroup),
                    ButtonsGroup(title: 'Support', items: supportGroup),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class GeneralGroup extends StatelessWidget {
  const GeneralGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onTapNotifications() {
      context.read<SettingsBloc>().add(const ToggleNotifications());
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 2),
              child: Text(
                'General',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Material(
              color: const Color.fromRGBO(0, 186, 195, 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: InkWell(
                onTap: () => onTapNotifications(),
                highlightColor: Colors.white24,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SvgPicture.asset(
                          Assets.icons.notification,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      const Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            'Notifications',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )),
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 0.9,
                          child: Switch(
                            inactiveThumbColor: Colors.teal.shade900,
                            trackOutlineColor:
                                MaterialStatePropertyAll(Colors.teal.shade900),
                            activeColor: Colors.white,
                            activeTrackColor: Colors.teal.shade900,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: state.isNotificationsEnabled,
                            onChanged: (value) => onTapNotifications(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ButtonsGroup extends StatelessWidget {
  final String title;
  final List<ButtonItem> items;
  const ButtonsGroup({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 186, 195, 1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: items
                .map(
                  (item) => Column(
                    children: [
                      Material(
                        color: const Color.fromRGBO(0, 186, 195, 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: InkWell(
                          onTap: () => item.onTap(),
                          highlightColor: Colors.white24,
                          // borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SvgPicture.asset(
                                    item.leadingIcon,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      item.title,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: item.trailing ??
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Colors.white,
                                        ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (items.indexOf(item) != items.length - 1)
                        const Divider(
                          height: 1,
                          color: Colors.white,
                        )
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
