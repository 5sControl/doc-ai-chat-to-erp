

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/subscribtions_screen/terms_restore_privacy.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';

class BundleScreen1 extends StatelessWidget {
  const BundleScreen1({
    super.key,
    required this.packages,
    required this.selectedSubscriptionIndex,
    required this.onSelectSubscription,
    this.fromOnboarding,
  });

  final bool? fromOnboarding;
  final List<Package> packages;
  final int selectedSubscriptionIndex;
  final Function({required int index}) onSelectSubscription;

  @override
  Widget build(BuildContext context) {
    
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: isTablet ? 10 : 0,
          ),
          Title(fromOnboarding: fromOnboarding,),
          SizedBox(
            height: isTablet ? 10 : 0,
          ),
          const Body(),
          SizedBox(
            height: isTablet ? 40 : 5,
          ),
          const Body1(),
          SizedBox(
            height: isTablet ? 30 : 13,
          ),
          PricesBloc(
            packages: packages,
            selectedSubscriptionIndex: selectedSubscriptionIndex,
            onSelectSubscription: onSelectSubscription,
          ),
          SizedBox(
            height: isTablet ? 20 : 3,
          ),
          SubscribeButton(
            package: packages[selectedSubscriptionIndex],
          ),
          SizedBox(
            height: isTablet ? 10 : 0,
          ),
          const TermsRestorePrivacy()
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Column(
      children: [
        Center(
          child: Text(
            'BUY',
            style: TextStyle(
                fontSize: isTablet ? 34 : 26, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: isTablet ? 30 : 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.transcriptor1,
                    height: isTablet ? 88 : 68,
                  ),
                  Text(
                    'SpeechScribe',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 20 : 16),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // ),
            SvgPicture.asset(
              Assets.icons.plus,
              height: isTablet? 50 : 36,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            // const SizedBox(
            //   width: 35,
            // ),
            Expanded(
              child: Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.summifyLogo,
                    height: isTablet ? 88 : 68,
                  ),
                  Text(
                    'Summify',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 20 : 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Body1 extends StatelessWidget {
  const Body1({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressDesktop() {
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
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Container(
      height: isTablet ? 300 : 210,
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      //color: Colors.white.withOpacity(0.6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(227, 255, 254, 1)),
      child: Column(
        children: [
          SizedBox(
            height: isTablet ? 10 : 4,
          ),
          Text(
            'GET FOR FREE',
            style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 34 : 26,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: isTablet ? 30 : 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.transcriptor2,
                      height: isTablet ? 88 : 68,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: onPressDesktop,
                      child: Text(
                        'SpeechScribe',
                        style: TextStyle(
                            fontSize: isTablet ? 20 : 16,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                Assets.icons.plus,
                 height: isTablet? 50 : 36,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.logo,
                      height: isTablet ? 88 : 75,
                      color: Colors.black87,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: onPressDesktop,
                      child: Text(
                        'Summify',
                        style: TextStyle(
                            fontSize: isTablet ? 20 : 16,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: isTablet ? 30 : 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'on',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                Assets.icons.chrome,
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'Version',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class Title extends StatefulWidget {
  final bool? fromOnboarding;
  const Title({super.key, this.fromOnboarding});

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  final List<List<String>> wordPairs = [
    ['Unlock Limitless', 'Possibilities'],
    ['Endless Possibilities', 'with 50% Off'],
    ['Get 4 Unlimited Apps', 'with 50% Off'],
  ];

  List<String> displayedPair = ["", ""];
  int index = 0;

  List<String> getRandomPair() {
    final random = Random();
    index = random.nextInt(wordPairs.length);
    return wordPairs[index];
  }

  @override
  void initState() {
    super.initState();
    displayedPair = getRandomPair();
    if(widget.fromOnboarding == null){
    context
        .read<MixpanelBloc>()
        .add(BundleScreenLimShow(trigger: 'Settings', screen: 'Offer screen $index'));}
        else if (widget.fromOnboarding != null){
          context
        .read<MixpanelBloc>()
        .add(BundleScreenLim1Show(trigger: 'Onboarding', screen: 'Offer screen $index'));
        }
  }

  void refreshPair() {
    setState(() {
      displayedPair = getRandomPair();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: AutoSizeText.rich(
        textAlign: TextAlign.center,
        TextSpan(children: [
          TextSpan(
            text: '${displayedPair[0]}\n',
            style: TextStyle(
                fontSize: isTablet ? 40 : 28,
                fontWeight: FontWeight.w700,
                height: 1,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          TextSpan(
              text: '${displayedPair[1]}',
              style: TextStyle(
                fontSize: displayedPair[1] == 'with 50% Off'
                    ? isTablet
                        ? 55
                        : 36
                    : isTablet
                        ? 40
                        : 28,
                color: displayedPair[1] == 'with 50% Off' 
                    ? const Color.fromRGBO(0, 186, 195, 1)
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.bold,
              ))
        ]),
      ),
    );
  }
}

class PricesBloc extends StatelessWidget {
  final int selectedSubscriptionIndex;
  final List<Package> packages;
  final Function({required int index}) onSelectSubscription;
  const PricesBloc(
      {super.key,
      required this.packages,
      required this.selectedSubscriptionIndex,
      required this.onSelectSubscription});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          SubscriptionCover(
            onSelectSubscription: onSelectSubscription,
            isSelected: selectedSubscriptionIndex == 0,
            package: packages[0],
            index: 0,
          ),
          const SizedBox(
            width: 5,
          ),
          SubscriptionCover(
            onSelectSubscription: onSelectSubscription,
            isSelected: selectedSubscriptionIndex == 1,
            package: packages[1],
            index: 1,
          ),
        ],
      ),
    );
  }
}

class SubscriptionCover extends StatelessWidget {
  final bool isSelected;
  final Package package;
  final Function({required int index}) onSelectSubscription;
  final int index;
  const SubscriptionCover(
      {super.key,
      required this.package,
      required this.isSelected,
      required this.onSelectSubscription,
      required this.index});

  @override
  Widget build(BuildContext context) {
    String subscriptionTitle = '';
    switch (package.storeProduct.identifier) {
      case 'SummifyMonthlyBundleSubscription' || 'summify_bundle_week':
        subscriptionTitle = '1 month';
      case 'SummifyAnnualBundleSubscription' || 'summify_bundle_month':
        subscriptionTitle = '12 months';
    }

    final textColor = Theme.of(context).brightness == Brightness.light
        ? isSelected
            ? Colors.white
            : Colors.black
        : Colors.white;

    String currency({required String code}) {
      Locale locale = Localizations.localeOf(context);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      return format.currencySymbol;
    }

    return Expanded(
      child: SizedBox(
        height:MediaQuery.of(context).size.shortestSide >= 600 ? 150 : 110,
        child: GestureDetector(
          onTap: () => onSelectSubscription(index: index),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromRGBO(0, 186, 195, 1)
                    : Colors.white12,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white,
                    width: 2)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isSelected)
                  Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset(Assets.icons.discount),
                  ),
                if (isSelected)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(Assets.icons.checkCircle)),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        subscriptionTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      // const Divider(
                      //   color: Colors.transparent,
                      // ),
                      Text(
                        package.storeProduct.priceString,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400),
                      ),
                      Text(
                        '${currency(code: package.storeProduct.currencyCode)} ${(package.storeProduct.price * 2).toStringAsFixed(2)}',
                        style: TextStyle(
                            color: textColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscribeButton extends StatefulWidget {
  final Package? package;
  const SubscribeButton({super.key, required this.package});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    void onPressGoPremium() {
      if (widget.package != null) {
        context
            .read<SubscriptionsBloc>()
            .add(MakePurchase(context: context, product: widget.package!));
      }
    }

    void onPressGoPremiumNotAuth() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 0),
      child: Material(
        color: Color.fromRGBO(0, 186, 195, 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: _auth.currentUser != null
              ? onPressGoPremium
              : onPressGoPremiumNotAuth,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: const Text(
              'Continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}