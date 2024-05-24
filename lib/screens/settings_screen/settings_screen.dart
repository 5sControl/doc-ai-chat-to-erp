import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/modal_screens/set_up_share_screen.dart';
import 'package:summify/screens/settings_screen/select_lang_dialog.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../subscribtions_screen/subscriptions_screen.dart';

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
          return const SubscriptionScreen(fromOnboarding: true,);
        },
      );
    }

    void onPressRestore() async {
      context
          .read<SubscriptionsBloc>()
          .add(RestoreSubscriptions(context: context));
    }

    void onPressOurApps() async {
      if (Platform.isIOS) {
        final Uri url = Uri.parse(
            'https://apps.apple.com/ru/developer/english-in-games/id1656052466');
        if (!await launchUrl(url)) {}
      } else {
        final Uri url = Uri.parse(
            'https://play.google.com/store/apps/dev?id=8797601455128207838&hl=ru&gl=US');
        if (!await launchUrl(url)) {}
      }
    }

    void onPressRateApp() async {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }

    void onPressFeedback() async {
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
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const SetUpShareScreen();
        },
      );
    }

    void onTapNotifications() {
      context.read<SettingsBloc>().add(const ToggleNotifications());
    }

    final List<ButtonItem> generalGroup = [
      ButtonItem(
        title: 'Notifications',
        leadingIcon: Assets.icons.notification,
        onTap: onTapNotifications,
        trailing: const NotificationsSwitch(),
      ),
      ButtonItem(
          title: 'Translation language',
          leadingIcon: Assets.icons.translate,
          onTap: () => translateDialog(context: context),
          trailing: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Row(
                children: [
                  Text(
                    state.translateLanguage.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  )
                ],
              );
            },
          )),
      ButtonItem(
        title: 'Dark mode',
        leadingIcon: Assets.icons.theme,
        onTap: () {},
        trailing: const ThemeButtons(),
      ),
    ];

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
        leadingIcon: Assets.icons.setUp,
        onTap: onPressSetupShare,
      ),
      if (Platform.isIOS)
        ButtonItem(
          title: 'Rate Summify',
          leadingIcon: Assets.icons.star,
          onTap: onPressRateApp,
        ),
      if (Platform.isIOS)
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
      if (Platform.isIOS)
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
            title: const Text(
              'Settings',
            ),
          ),
          body: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ButtonsGroup(title: 'General', items: generalGroup),
                    ButtonsGroup(title: 'Membership', items: membershipGroup),
                    ButtonsGroup(title: 'About', items: aboutGroup),
                    ButtonsGroup(title: 'Support', items: supportGroup),
                    Text('version 1.3.0',
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 2))
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class ThemeButtons extends StatefulWidget {
  const ThemeButtons({super.key});

  @override
  State<ThemeButtons> createState() => _ThemeButtonsState();
}

class ThemeItem {
  final String title;
  final AppTheme appTheme;
  ThemeItem({required this.title, required this.appTheme});
}

class _ThemeButtonsState extends State<ThemeButtons> {
  List<ThemeItem> themeItems = [
    ThemeItem(title: 'Auto', appTheme: AppTheme.auto),
    ThemeItem(title: 'On', appTheme: AppTheme.dark),
    ThemeItem(title: 'Off', appTheme: AppTheme.light),
  ];

  void onSelectTheme({required AppTheme appTheme}) {
    context.read<SettingsBloc>().add(SelectAppTheme(appTheme: appTheme));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: themeItems
                .map((themeItem) => Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: themeItem.appTheme == state.appTheme
                              ? Theme.of(context).highlightColor
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(6)),
                      child: InkWell(
                        onTap: () =>
                            onSelectTheme(appTheme: themeItem.appTheme),
                        child: Text(
                          themeItem.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: themeItem.appTheme == state.appTheme
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class NotificationsSwitch extends StatelessWidget {
  const NotificationsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    void onTapNotifications() {
      context.read<SettingsBloc>().add(const ToggleNotifications());
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return SizedBox(
          height: 20,
          child: Transform.scale(
            scale: 0.9,
            child: Switch(
              inactiveThumbColor: Colors.grey.shade500,
              trackOutlineColor:
                  MaterialStatePropertyAll(Theme.of(context).highlightColor),
              activeColor: Theme.of(context).highlightColor,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: state.isNotificationsEnabled,
              onChanged: (value) => onTapNotifications(),
            ),
          ),
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
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: items
                .map(
                  (item) => Column(
                    children: [
                      Material(
                        color: Theme.of(context).primaryColor,
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
