import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/subscription_screen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/settings/settings_bloc.dart';
import '../widgets/premium_banner.dart';

// class ButtonItem {
//   final String title;
//   final Widget icon;
//   final Function onTap;
//   const ButtonItem(
//       {required this.title, required this.icon, required this.onTap});
// }

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Column(
                children: [
                  PremiumBanner(),
                  GeneralGroup(),
                  ManageGroup(),
                  OtherGroup(),
                  AboutGroup()
                ],
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(Assets.icons.notification),
                  ),
                  const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'Notification',
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
                        activeColor: Colors.white,
                        activeTrackColor: Colors.teal.shade900,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: state.isNotificationsEnabled,
                        onChanged: (value) => onTapNotifications(),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class ManageGroup extends StatelessWidget {
  const ManageGroup({
    super.key,
  });

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

    void onPressRestore() {

    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'Membership',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 188, 183, 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressSubscription,
                    highlightColor: Colors.white24,
                    // borderRadius: BorderRadius.circular(8),
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
                              Assets.icons.star,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Subscription',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressRestore,
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
                              Assets.icons.restore,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Restore',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ))
      ],
    );
  }
}

class OtherGroup extends StatelessWidget {
  const OtherGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    void onPressOurApps() async {
      final Uri url = Uri.parse(
          'https://apps.apple.com/ru/developer/english-in-games/id1656052466');
      if (!await launchUrl(url)) {}
    }
    void onPressRateApp() {}
    void onPressFeedback() {}
    void onPressCredits() {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'About',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 188, 183, 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressOurApps,
                    highlightColor: Colors.white24,
                    // borderRadius: BorderRadius.circular(8),
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
                              Assets.icons.phone,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Our apps',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressRateApp,
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
                              Assets.icons.star,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Rate app',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressFeedback,
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
                              Assets.icons.chat,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Leave feedback',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}

class AboutGroup extends StatelessWidget {
  const AboutGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    void onPressOurApps() async {
      final Uri url = Uri.parse(
          'https://apps.apple.com/ru/developer/english-in-games/id1656052466');
      if (!await launchUrl(url)) {}
    }
    void onPressRateApp() {}
    void onPressFeedback() {}
    void onPressCredits() {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'Support',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 188, 183, 1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressOurApps,
                    highlightColor: Colors.white24,
                    // borderRadius: BorderRadius.circular(8),
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
                              Assets.icons.phone,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Terms of use',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressRateApp,
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
                              Assets.icons.star,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Privacy policy',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 1,
                ),
                Material(
                  color: const Color.fromRGBO(30, 188, 183, 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: onPressFeedback,
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
                              Assets.icons.chat,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          const Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                'Share this app',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
