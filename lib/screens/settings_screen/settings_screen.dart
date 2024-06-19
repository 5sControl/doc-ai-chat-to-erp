import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../subscribtions_screen/subscriptions_screen.dart';
import '../summary_screen/info_modal/extension_modal.dart';

class ButtonItem {
  final String title;
  final String leadingIcon;
  final Widget? trailing;
  final Gradient? background;
  final Function onTap;

  const ButtonItem(
      {required this.title,
      required this.leadingIcon,
      required this.onTap,
      this.trailing,
      this.background});
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
          return const SubscriptionScreen(
            fromOnboarding: true,
            triggerScreen: 'Settings',
          );
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

    void onPressChrome() {
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (context) {
          return const ExtensionModal();
        },
      );
      context.read<MixpanelBloc>().add(const OpenSummifyExtensionModal());
    }

    final List<ButtonItem> mainGroup = [
      ButtonItem(
          title: 'Subscription',
          leadingIcon: Assets.icons.crown,
          onTap: onPressSubscription,
          trailing: Container(
              width: 85,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 238, 90, 1),
                    Color.fromRGBO(255, 208, 74, 1)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: const Text(
                'Upgrade',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ))),
      ButtonItem(
        title: 'Add Summify for Chrome',
        leadingIcon: Assets.icons.chromeMini,
        trailing: Container(
            width: 85,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(255, 238, 90, 1),
                  Color.fromRGBO(255, 208, 74, 1)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: const Text(
              'Free',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            )),
        onTap: onPressChrome,
      ),
      ButtonItem(
        title: 'Request a feature',
        leadingIcon: Assets.icons.chat,
        onTap: onPressFeedback,
      ),
      if (Platform.isIOS)
        ButtonItem(
          title: 'Rate Summify',
          leadingIcon: Assets.icons.star,
          onTap: onPressRateApp,
        ),
    ];

    final List<ButtonItem> generalGroup = [
      ButtonItem(
          title: 'Translation language',
          leadingIcon: Assets.icons.translate,
          onTap: () => translateDialog(context: context),
          trailing: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Row(
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
                  )
                ],
              );
            },
          )),
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

    final List<ButtonItem> aboutGroup = [
      ButtonItem(
        title: 'Set up share button',
        leadingIcon: Assets.icons.setUp,
        onTap: onPressSetupShare,
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
        title: 'Restore purchase',
        leadingIcon: Assets.icons.restore,
        onTap: onPressRestore,
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
                    MainGroup(
                      items: mainGroup,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ButtonsGroup(title: 'General', items: generalGroup),
                    // ButtonsGroup(title: 'Membership', items: membershipGroup),
                    ButtonsGroup(title: 'About', items: aboutGroup),
                    ButtonsGroup(title: 'Support', items: supportGroup),
                    Text('version 1.4.0',
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1))
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

class MainGroup extends StatelessWidget {
  // final String title;
  final List<ButtonItem> items;

  const MainGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                            decoration: BoxDecoration(
                                gradient: item.background,
                                borderRadius: item.background != null
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))
                                    : const BorderRadius.all(
                                        Radius.circular(8))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SvgPicture.asset(
                                    item.leadingIcon,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!,
                                        BlendMode.srcIn),
                                  ),
                                ),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      item.title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: item.trailing ??
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color,
                                        ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (items.indexOf(item) != items.length - 1)
                        Divider(
                          height: 1,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withOpacity(0.5),
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

class ButtonsGroup extends StatefulWidget {
  final String title;
  final List<ButtonItem> items;

  const ButtonsGroup({super.key, required this.title, required this.items});

  @override
  State<ButtonsGroup> createState() => _ButtonsGroupState();
}

class _ButtonsGroupState extends State<ButtonsGroup> {
  bool isOpen = true;

  void onToggleOpen() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.only(bottom: 0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // IconButton(
                //     visualDensity: VisualDensity.compact,
                //     padding: EdgeInsets.zero,
                //     color: Theme.of(context).textTheme.bodyMedium!.color,
                //     style: const ButtonStyle(
                //         iconSize: MaterialStatePropertyAll(20)),
                //     onPressed: onToggleOpen,
                //     icon: Transform.rotate(
                //         angle: !isOpen ? -pi : -pi / 2,
                //         child: const Icon(Icons.arrow_back_ios_rounded)))
              ],
            )),
        AnimatedCrossFade(
            firstChild: Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: widget.items
                    .map(
                      (item) => Column(
                        children: [
                          Material(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: InkWell(
                              onTap: () => item.onTap(),
                              highlightColor: Colors.white24,
                              // borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    gradient: item.background,
                                    borderRadius: item.background != null
                                        ? const BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8))
                                        : const BorderRadius.all(
                                            Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: SvgPicture.asset(
                                        item.leadingIcon,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color!,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          item.title,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: item.trailing ??
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .color,
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (widget.items.indexOf(item) !=
                              widget.items.length - 1)
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .color!
                                  .withOpacity(0.5),
                            )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            secondChild: Container(),
            crossFadeState:
                isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 300)),
      ],
    );
  }
}
