import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../modal_screens/purchase_success_screen.dart';
import '../subscription_screen.dart';
import 'happy_box.dart';
import 'subscription_body_month.dart';
import 'subscription_body_year.dart';

class SubscriptionOnboardingScreen extends StatefulWidget {
  const SubscriptionOnboardingScreen({super.key});

  @override
  State<SubscriptionOnboardingScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionOnboardingScreen> {
  var selectedSubscriptionIndex = 1;

  void onSelectSubscription({required int index}) {
    setState(() {
      selectedSubscriptionIndex = index;
    });
  }

  @override
  void initState() {
    context.read<MixpanelBloc>().add(const PaywallShow(trigger: 'onboarding'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final abTest = context.read<SettingsBloc>().state.abTest;

    void onSubscriptionsComplete() {
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (context) {
          return const PurchaseSuccessScreen();
        },
      );
    }

    return BlocConsumer<SubscriptionsBloc, SubscriptionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final abTest = context.read<SettingsBloc>().state.abTest;

        const double headerH = 0.16;
        List<Package> packages =
            List.from(state.availableProducts!.current!.availablePackages);
        packages.sort(
            (a, b) => a.storeProduct.price.compareTo(b.storeProduct.price));

        final monthlyPackage = packages.firstWhere(
            (element) => element.packageType == PackageType.monthly);
        final annualPackage = packages
            .firstWhere((element) => element.packageType == PackageType.annual);

        return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            return Stack(
              children: [
                const BackgroundGradient(),
                Animate(
                  effects: const [FadeEffect()],
                  child: SafeArea(
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        actions: const [
                          BackArrow(),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Title(),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8)),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                reverseDuration:
                                    const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  key: Key(selectedSubscriptionIndex == 1
                                      ? 'month'
                                      : 'year'),
                                  child: Builder(
                                    builder: (context) {
                                      if (selectedSubscriptionIndex == 1) {
                                        return CustomPaint(
                                          painter:
                                              PainterRight(headerH: headerH),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SizedBox(
                                                width: double.infinity,
                                                height: constraints.maxHeight,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          headerH,
                                                      child: Row(
                                                        children: [
                                                          MonthTitle(
                                                              onSelectSubscription:
                                                                  onSelectSubscription),
                                                          YearTitle(
                                                              onSelectSubscription:
                                                                  onSelectSubscription)
                                                        ],
                                                      ),
                                                    ),
                                                    SubscriptionBodyYear(
                                                        package: annualPackage)
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return CustomPaint(
                                          painter:
                                              PainterLeft(headerH: headerH),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SizedBox(
                                                width: double.infinity,
                                                height: constraints.maxHeight,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          headerH,
                                                      child: Row(
                                                        children: [
                                                          MonthTitle(
                                                              onSelectSubscription:
                                                                  onSelectSubscription),
                                                          YearTitle(
                                                              onSelectSubscription:
                                                                  onSelectSubscription)
                                                        ],
                                                      ),
                                                    ),
                                                    SubscriptionBodyMonth(
                                                      package: monthlyPackage,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const TermsRestorePrivacy()
                        ],
                      ),
                    ),
                  ),
                ),
                Animate(effects: const [
                  MoveEffect(begin: Offset(100, 0), end: Offset(0, 0)),
                ], child: const HappyBox())
              ],
            );
          },
        );
      },
    );
  }
}

class MonthTitle extends StatelessWidget {
  final Function({required int index}) onSelectSubscription;
  const MonthTitle({super.key, required this.onSelectSubscription});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onSelectSubscription(index: 0),
      child: Center(
        child: Text(
          'Pay\nmonthly',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ));
  }
}

class YearTitle extends StatelessWidget {
  final Function({required int index}) onSelectSubscription;
  const YearTitle({super.key, required this.onSelectSubscription});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onSelectSubscription(index: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pay\nannually',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(255, 238, 90, 1),
                  Color.fromRGBO(255, 208, 74, 1),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Text(
              'Save up to 25\$',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    ));
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Text(
        'Be smart with your time!',
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1),
      ),
    );
  }
}

class IconsRow extends StatelessWidget {
  const IconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w700),
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
        ]));
  }
}

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      context.read<MixpanelBloc>().add(const ClosePaywall());
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0.2))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.2),
        icon: Icon(
          Icons.close,
          size: 20,
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

// class PricesBloc extends StatelessWidget {
//   final int selectedSubscriptionIndex;
//   final List<Package> packages;
//   final Function({required int index}) onSelectSubscription;
//   const PricesBloc(
//       {super.key,
//       required this.packages,
//       required this.selectedSubscriptionIndex,
//       required this.onSelectSubscription});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SubscriptionCover(
//           onSelectSubscription: onSelectSubscription,
//           isSelected: selectedSubscriptionIndex == 0,
//           package: packages[0],
//           index: 0,
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         SubscriptionCover(
//           onSelectSubscription: onSelectSubscription,
//           isSelected: selectedSubscriptionIndex == 1,
//           package: packages[1],
//           index: 1,
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         SubscriptionCover(
//           onSelectSubscription: onSelectSubscription,
//           isSelected: selectedSubscriptionIndex == 2,
//           package: packages[2],
//           index: 2,
//         ),
//       ],
//     );
//   }
// }
//
// class SubscriptionCover extends StatelessWidget {
//   final bool isSelected;
//   final Package package;
//   final Function({required int index}) onSelectSubscription;
//   final int index;
//   const SubscriptionCover(
//       {super.key,
//       required this.package,
//       required this.isSelected,
//       required this.onSelectSubscription,
//       required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     String subscriptionTitle = '';
//     switch (package.storeProduct.identifier) {
//       case 'SummifyPremiumWeekly' || 'summify_premium_week':
//         subscriptionTitle = '1 \nweek';
//       case 'SummifyPremiumMonth' || 'summify_premium_month':
//         subscriptionTitle = '1 \nmonth';
//       case 'SummifyPremiumYear' || 'summify_premium_year':
//         subscriptionTitle = '12 \nmonths';
//     }
//
//     final textColor = Theme.of(context).brightness == Brightness.light
//         ? isSelected
//             ? Colors.white
//             : Colors.black
//         : Colors.white;
//
//     String currency({required String code}) {
//       Locale locale = Localizations.localeOf(context);
//       var format = NumberFormat.simpleCurrency(locale: locale.toString());
//       return format.currencySymbol;
//     }
//
//     return Expanded(
//       child: SizedBox(
//         height: 140,
//         child: GestureDetector(
//           onTap: () => onSelectSubscription(index: index),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: isSelected
//                     ? Theme.of(context).primaryColor
//                     : Colors.white12,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.white, width: 2)),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 if (isSelected)
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: SvgPicture.asset(Assets.icons.discount),
//                   ),
//                 if (isSelected)
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: SvgPicture.asset(Assets.icons.checkCircle)),
//                   ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       subscriptionTitle,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: textColor,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const Divider(
//                       color: Colors.transparent,
//                     ),
//                     Text(
//                       package.storeProduct.priceString,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.clip,
//                       style: TextStyle(
//                           color: textColor,
//                           fontSize: 18,
//                           fontWeight:
//                               isSelected ? FontWeight.w700 : FontWeight.w400),
//                     ),
//                     Text(
//                       '${currency(code: package.storeProduct.currencyCode)} ${(package.storeProduct.price * 2).toStringAsFixed(2)}',
//                       style: TextStyle(
//                           color: textColor,
//                           decoration: TextDecoration.lineThrough,
//                           decorationColor: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SubscribeButton extends StatefulWidget {
//   final Package? package;
//   const SubscribeButton({super.key, required this.package});
//
//   @override
//   State<SubscribeButton> createState() => _SubscribeButtonState();
// }
//
// class _SubscribeButtonState extends State<SubscribeButton> {
//   @override
//   Widget build(BuildContext context) {
//     void onPressGoPremium() {
//       if (widget.package != null) {
//         context
//             .read<SubscriptionsBloc>()
//             .add(MakePurchase(context: context, product: widget.package!));
//       }
//     }
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//       child: Material(
//         color: Theme.of(context).primaryColor,
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         child: InkWell(
//           highlightColor: Colors.white24,
//           borderRadius: BorderRadius.circular(8),
//           onTap: onPressGoPremium,
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: const Text(
//               'Submit',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   fontSize: 16),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
