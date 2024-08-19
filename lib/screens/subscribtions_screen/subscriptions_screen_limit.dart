import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/bloc/offers/offers_state.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/modal_screens/purchase_success_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';
import 'package:summify/screens/subscribtions_screen/terms_restore_privacy.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../summary_screen/info_modal/extension_modal.dart';
import 'happy_box.dart';
import 'subscription_body_month.dart';
import 'subscription_body_year.dart';

class SubscriptionScreenLimit extends StatefulWidget {
  final bool? fromOnboarding;
  final String triggerScreen;
  final bool fromSettings;
  const SubscriptionScreenLimit(
      {super.key,
      this.fromOnboarding,
      required this.triggerScreen,
      required this.fromSettings});

  @override
  State<SubscriptionScreenLimit> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreenLimit> {
  var selectedSubscriptionIndex = 2;

  void onSelectSubscription({required int index}) {
    setState(() {
      selectedSubscriptionIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final abTest = context.read<SettingsBloc>().state.abTest;

    // void onSubscriptionsComplete() {
    //   showMaterialModalBottomSheet(
    //     context: context,
    //     expand: false,
    //     bounce: false,
    //     barrierColor: Colors.black54,
    //     backgroundColor: Colors.transparent,
    //     enableDrag: false,
    //     builder: (context) {
    //       return const PurchaseSuccessScreen();
    //     },
    //   );
    // }

    void showSuccessScreen() {
      showMaterialModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          builder: (context) {
            return const PurchaseSuccessScreen();
          });
    }

    return BlocConsumer<SubscriptionsBloc, SubscriptionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        // final abTest = context.read<SettingsBloc>().state.abTest;

        const double headerH = 0.16;
        List<Package> packages =
            List.from(state.availableProducts!.current!.availablePackages);
        packages.sort(
            (a, b) => a.storeProduct.price.compareTo(b.storeProduct.price));

        // final monthlyPackage = packages.firstWhere(
        //     (element) => element.packageType == PackageType.annual);
        // final annualPackage = packages
        //     .firstWhere((element) => element.packageType == PackageType.annual);

        // List<Color?> colors = [
        //   Color.fromARGB(255, 255, 199, 59),
        //   null,
        //   null,
        //   Color.fromARGB(255, 255, 199, 59),
        //   null,
        //   null,
        // ];

        return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            return Stack(
              children: [
                const BackgroundGradient(),
                Animate(
                  effects: const [FadeEffect()],
                  child: SafeArea(
                    child: BlocBuilder<OffersBloc, OffersState>(
                        builder: (context, state) {
                      if (widget.fromSettings) {
                        context.read<MixpanelBloc>().add(SubScreenLimShow(
                            trigger: 'Settings',
                            screen: 'Offer screen ${state.screenIndex} '));
                      }
                      if (!widget.fromSettings) {
                        context.read<MixpanelBloc>().add(SubScreenLimShow(
                            trigger: 'Not from Settings',
                            screen: 'Offer screen ${state.screenIndex} '));
                      }
                      return state.screenIndex == 4
                          ? SubscriptionScreen(
                              triggerScreen: 'Home',
                              showBackArrow: widget.fromSettings,
                            )
                          : Scaffold(
                              appBar: AppBar(
                                //backgroundColor: Colors.black,
                                toolbarHeight:
                                    MediaQuery.of(context).size.shortestSide <
                                            600
                                        ? widget.fromSettings
                                            ? 235
                                            : 195
                                        : 635,
                                //toolbarOpacity: 20,
                                automaticallyImplyLeading: false,
                                flexibleSpace: Stack(
                                  children: [
                                    Human(),
                                    widget.fromSettings
                                        ? Positioned(
                                            top: 10,
                                            right: 10,
                                            child: BackArrow(
                                                fromOnboarding:
                                                    widget.fromOnboarding))
                                        : Container()
                                  ],
                                ),
                                actions: [],
                              ),
                              body: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      //const Human(),
                                      state.screenIndex == 1 ||
                                              state.screenIndex == 2
                                          ? SizedBox(
                                              height: 40,
                                            )
                                          : Container(),
                                      state.screenIndex == 1
                                          ? SizedBox(
                                              height: 20,
                                            )
                                          : Container(),
                                      const Title(),

                                      const SubTitle(),
                                      state.screenIndex < 3 &&
                                              state.screenIndex != 1
                                          ? const SizedBox(
                                              height: 35,
                                            )
                                          : SizedBox(
                                              height: 10,
                                            ),

                                      Spacer(),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            state.screenIndex < 3
                                                ? const Text1()
                                                : Container(),
                                            //const TermsRestorePrivacy()
                                            state.screenIndex < 3
                                                ? const SizedBox(
                                                    height: 15,
                                                  )
                                                : Container(),
                                            PricesBloc(
                                              packages: packages,
                                              selectedSubscriptionIndex:
                                                  selectedSubscriptionIndex,
                                              onSelectSubscription:
                                                  onSelectSubscription,
                                              fromSettings: widget.fromSettings,
                                            ),
                                            SubscribeButton(
                                              package: packages[
                                                  selectedSubscriptionIndex],
                                            ),
                                            const TermsRestorePrivacy()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// class WeekTitle extends StatelessWidget {
//   final Function({required int index}) onSelectSubscription;
//   const WeekTitle({super.key, required this.onSelectSubscription});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: InkWell(
//       borderRadius: BorderRadius.circular(8),
//       onTap: () => onSelectSubscription(index: 0),
//       child: Center(
//         child: Text(
//           'Pay weekly',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ),
//     ));
//   }
// }

// class MonthTitle extends StatelessWidget {
//   final Function({required int index}) onSelectSubscription;
//   const MonthTitle({super.key, required this.onSelectSubscription});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: InkWell(
//       borderRadius: BorderRadius.circular(8),
//       onTap: () => onSelectSubscription(index: 0),
//       child: Center(
//         child: Text(
//           'Pay monthly',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ),
//     ));
//   }
// }

// class YearTitle extends StatelessWidget {
//   final Function({required int index}) onSelectSubscription;
//   const YearTitle({super.key, required this.onSelectSubscription});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: InkWell(
//       borderRadius: BorderRadius.circular(8),
//       onTap: () => onSelectSubscription(index: 1),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Pay annually',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodySmall,
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               // gradient: const LinearGradient(colors: [
//               //   Color.fromRGBO(255, 238, 90, 1),
//               //   Color.fromRGBO(255, 208, 74, 1),
//               // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
//             ),
//             child: Text('Save up to 29\$',
//                 style: Theme.of(context).textTheme.bodySmall!
//                 // .copyWith(color: Colors.black),
//                 ),
//           )
//         ],
//       ),
//     ));
//   }
// }

class Human extends StatelessWidget {
  const Human({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> screenTexts = [
      Assets.subscriptionWoman1.path,
      Theme.of(context).brightness == Brightness.dark
          ? Assets.subscriptionWoman.path
          : Assets.subscriptionWomanLight.path,
      Theme.of(context).brightness == Brightness.dark
          ? Assets.subscriptionMen.path
          : Assets.subscriptionMenLight.path,
      Assets.subscriptionWoman1.path,
      Theme.of(context).brightness == Brightness.dark
          ? Assets.subscriptionWoman.path
          : Assets.subscriptionWomanLight.path,
      Theme.of(context).brightness == Brightness.dark
          ? Assets.subscriptionMen.path
          : Assets.subscriptionMenLight.path,
    ];
    // List<Color?> colors = [
    //   Color.fromARGB(255, 255, 199, 59),
    //   null,
    //   null,
    //   Color.fromARGB(255, 255, 199, 59),
    //   null,
    //   null,
    // ];
    return BlocBuilder<OffersBloc, OffersState>(builder: (context, state) {
      return Container(
        //color: colors[state.screenIndex],
        child: Image.asset(
          screenTexts[state.screenIndex],
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    });
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final List<String> screenTexts = [
      'Need more summaries?',
      'Maximize your productivity!',
      'Out of Summaries?',
      'Need more summaries?',
      'Maximize your productivity!',
      'Out of Summaries?',
    ];
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 4, bottom: 4),
        child: BlocBuilder<OffersBloc, OffersState>(builder: (context, state) {
          return Text(
            screenTexts[state.screenIndex],
            textAlign: TextAlign.start,
            style: state.screenIndex < 3
                ? TextStyle(
                    fontSize: isTablet ? 56 : 46,
                    fontWeight: FontWeight.w700,
                    height: 1)
                : TextStyle(
                    fontSize: 48, fontWeight: FontWeight.w700, height: 1),
          );
        }),
      ),
    );
  }
}

Widget buildRichText(BuildContext context, String text, {bool isLink = false}) {
  bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(Icons.check_circle, color: Colors.teal, size: 20),
          ),
          WidgetSpan(
              child: SizedBox(width: 8)), // Add space between icon and text
          TextSpan(
            text: text,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              decoration:
                  isLink ? TextDecoration.underline : TextDecoration.none,
              fontSize: isTablet ? 24 : 18,
            ),
          ),
        ],
      ),
    ),
  );
}

class SubTitle extends StatelessWidget {
  const SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final List<String> screenTexts = [
      'Maximize your productivity\nand efficiency!',
      '',
      'Get more in no time!',
    ];
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: BlocBuilder<OffersBloc, OffersState>(builder: (context, state) {
          return state.screenIndex < 3
              ? Text.rich(
                  TextSpan(
                    text: screenTexts[state.screenIndex],
                    style: TextStyle(
                        fontSize: isTablet ? 36 : 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  textAlign: TextAlign.start,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRichText(context, 'Unlimited Summaries'),
                    buildRichText(context, 'Document Research'),
                    buildRichText(context, 'Brief and Deep Summary'),
                    buildRichText(context, 'Translation'),
                    buildRichText(context, 'Add to Chrome for FREE',
                        isLink: true),
                  ],
                );
        }),
      ),
    );
  }
}

class Text1 extends StatelessWidget {
  const Text1({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final List<String> screenTexts = [
      '15 Deep Summaries Daily',
      '15 Deep Summaries Daily',
      '15 Deep Summaries Daily',
      '',
      '',
      '',
    ];
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: BlocBuilder<OffersBloc, OffersState>(builder: (context, state) {
          return Center(
            child: Text(
              screenTexts[state.screenIndex],
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: isTablet ? 36 : 24,
                  fontWeight: FontWeight.w700,
                  height: 1),
            ),
          );
        }),
      ),
    );
  }
}

class IconsRow extends StatelessWidget {
  const IconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressInfo() {
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const ExtensionModal();
        },
      );

      context.read<MixpanelBloc>().add(const OpenSummifyExtensionModal());
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)]),
      child: TextButton(
        onPressed: onPressInfo,
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white)),
        child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0,
                    color: Colors.black),
                children: [
              const TextSpan(text: "BUY "),
              WidgetSpan(
                  child: SvgPicture.asset(Assets.icons.summafyMini),
                  alignment: PlaceholderAlignment.middle),
              const TextSpan(text: " AND GET ON "),
              WidgetSpan(
                  child: SvgPicture.asset(Assets.icons.chrome),
                  alignment: PlaceholderAlignment.middle),
              const TextSpan(text: " FOR FREE!"),
            ])),
      )
          .animate(
            autoPlay: true,
            onPlay: (controller) => controller.repeat(),
          )
          .shimmer(
              color: Colors.white,
              duration: const Duration(milliseconds: 1500),
              delay: const Duration(seconds: 1)),
    );
  }
}

class BackArrow extends StatelessWidget {
  final bool? fromOnboarding;
  const BackArrow({super.key, this.fromOnboarding});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      if (fromOnboarding != null) {
        Navigator.of(context).pushNamed('/');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all<Size>(Size(33, 33)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
        icon: Icon(
          Icons.close,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}

class PainterRight extends CustomPainter {
  final double headerH;
  PainterRight({required this.headerH});

  @override
  void paint(Canvas canvas, Size size) {
    const r = 8.0;
    Paint paintFill0 = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0 + r, size.height * headerH);
    path_0.arcToPoint(Offset(size.width * 0, size.height * headerH + r),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 0, size.height * 1 - r);
    path_0.arcToPoint(Offset(size.width * 0 + r, size.height),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 1 - r, size.height * 1);
    path_0.arcToPoint(Offset(size.width * 1, size.height - r),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 1, size.height * 0 + r);
    path_0.arcToPoint(Offset(size.width * 1 - r, size.height * 0),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 0.5 + r, size.height * 0);
    path_0.arcToPoint(Offset(size.width * 0.5, size.height * 0 + r),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 0.5, size.height * headerH - r);
    path_0.arcToPoint(Offset(size.width * 0.5 - r, size.height * headerH),
        radius: const Radius.circular(r), clockwise: true);
    path_0.close();

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    Paint paintStroke0 = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PainterLeft extends CustomPainter {
  final double headerH;
  PainterLeft({required this.headerH});

  @override
  void paint(Canvas canvas, Size size) {
    const r = 8.0;
    Paint paintFill0 = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0 + r, size.height * 0);
    path_0.arcToPoint(Offset(size.width * 0, size.height * 0 + r),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 0, size.height * 1 - r);
    path_0.arcToPoint(Offset(size.width * 0 + r, size.height),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 1 - r, size.height * 1);
    path_0.arcToPoint(Offset(size.width * 1, size.height - r),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 1, size.height * headerH + r);
    path_0.arcToPoint(Offset(size.width * 1 - r, size.height * headerH),
        radius: const Radius.circular(r), clockwise: false);
    path_0.lineTo(size.width * 0.5 + r, size.height * headerH);
    path_0.arcToPoint(Offset(size.width * 0.5, size.height * headerH - r),
        radius: const Radius.circular(r), clockwise: true);
    path_0.lineTo(size.width * 0.5, size.height * 0 + r);
    path_0.arcToPoint(Offset(size.width * 0.5 - r, size.height * 0),
        radius: const Radius.circular(r), clockwise: false);
    path_0.close();

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    Paint paintStroke0 = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PricesBloc extends StatelessWidget {
  final int selectedSubscriptionIndex;
  final List<Package> packages;
  final Function({required int index}) onSelectSubscription;
  final bool fromSettings;
  const PricesBloc(
      {super.key,
      required this.packages,
      required this.selectedSubscriptionIndex,
      required this.onSelectSubscription,
      required this.fromSettings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          SubscriptionCover(
            onSelectSubscription: onSelectSubscription,
            isSelected: selectedSubscriptionIndex == 0,
            package: packages[0],
            index: 0,
            fromSettings: fromSettings,
          ),
          const SizedBox(
            width: 5,
          ),
          SubscriptionCover(
            onSelectSubscription: onSelectSubscription,
            isSelected: selectedSubscriptionIndex == 2,
            package: packages[2],
            index: 2,
            fromSettings: fromSettings,
          ),
          const SizedBox(
            width: 5,
          ),
          SubscriptionCover(
            onSelectSubscription: onSelectSubscription,
            isSelected: selectedSubscriptionIndex == 1,
            package: packages[1],
            index: 1,
            fromSettings: fromSettings,
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
  final bool fromSettings;
  const SubscriptionCover(
      {super.key,
      required this.package,
      required this.isSelected,
      required this.onSelectSubscription,
      required this.index,
      required this.fromSettings});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    String subscriptionTitle = '';
    switch (package.storeProduct.identifier) {
      case 'SummifyPremiumWeekly' || 'summify_premium_week':
        subscriptionTitle = '1 \nweek';
      case 'SummifyPremiumYear' || 'summify_premium_year':
        subscriptionTitle = '12 \nmonths';
      case 'SummifyPremiumMonth' || 'summify_premium_month':
        subscriptionTitle = '1 \nmonth';
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
        height: isTablet
            ? 180
            : fromSettings
                ? 150
                : 120,
        child: GestureDetector(
          onTap: () => onSelectSubscription(index: index),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white12,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).hintColor
                        : Colors.white,
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
                        padding: const EdgeInsets.all(10),
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
                            fontSize: isTablet ? 18 : 15,
                            fontWeight: FontWeight.w500),
                      ),
                      fromSettings
                          ? const Divider(
                              color: Colors.transparent,
                            )
                          : Container(),
                      Text(
                        package.storeProduct.priceString,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: textColor,
                            fontSize: isTablet ? 28 : 24,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400),
                      ),
                      Text(
                        '${currency(code: package.storeProduct.currencyCode)} ${(package.storeProduct.price * 2).toStringAsFixed(2)}',
                        style: TextStyle(
                            color: textColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white,
                            fontSize: isTablet ? 20 : 16,
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

//
class SubscribeButton extends StatefulWidget {
  final Package? package;
  const SubscribeButton({super.key, required this.package});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    void onPressGoPremium() {
      if (widget.package != null) {
        context
            .read<SubscriptionsBloc>()
            .add(MakePurchase(context: context, product: widget.package!));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: onPressGoPremium,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 10),
            child: const Text(
              'Go Premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
//
// class TermsRestorePrivacy extends StatelessWidget {
//   const TermsRestorePrivacy({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     void onPressTerms() async {
//       final Uri url = Uri.parse(
//           'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
//       if (!await launchUrl(url)) {}
//     }
//
//     void onPressRestore() async {
//       context
//           .read<SubscriptionsBloc>()
//           .add(RestoreSubscriptions(context: context));
//     }
//
//     void onPressPrivacy() async {
//       final Uri url = Uri.parse('https://elang.app/privacy');
//       if (!await launchUrl(url)) {}
//     }
//
//     return Row(
//       children: [
//         if (Platform.isIOS)
//           Expanded(
//             child: TextButton(
//               onPressed: onPressTerms,
//               style: const ButtonStyle(
//                   padding: MaterialStatePropertyAll(EdgeInsets.zero)),
//               child: Text(
//                 'Terms of use',
//                 style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 13,
//                     color: Theme.of(context).textTheme.bodyMedium!.color),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         Expanded(
//           child: TextButton(
//             onPressed: onPressRestore,
//             style: const ButtonStyle(
//                 padding: MaterialStatePropertyAll(EdgeInsets.zero)),
//             child: Text(
//               'Restore purchase',
//               style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 13,
//                   color: Theme.of(context).textTheme.bodyMedium!.color),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         if (Platform.isIOS)
//           Expanded(
//             child: TextButton(
//               onPressed: onPressPrivacy,
//               style: const ButtonStyle(
//                   padding: MaterialStatePropertyAll(EdgeInsets.zero)),
//               child: Text(
//                 'Privacy policy',
//                 style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 13,
//                     color: Theme.of(context).textTheme.bodyMedium!.color),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
