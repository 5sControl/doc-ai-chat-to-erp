import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/modal_screens/purchase_success_screen.dart';
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
  const SubscriptionScreenLimit(
      {super.key, this.fromOnboarding, required this.triggerScreen});

  @override
  State<SubscriptionScreenLimit> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreenLimit> {
  var selectedSubscriptionIndex = 1;

  void onSelectSubscription({required int index}) {
    setState(() {
      selectedSubscriptionIndex = index;
    });
  }

  @override
  void initState() {
    context
        .read<MixpanelBloc>()
        .add(PaywallShow(trigger: 'onboarding', screen: widget.triggerScreen));
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

        final monthlyPackage = packages.firstWhere(
            (element) => element.packageType == PackageType.weekly);
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
                        backgroundColor: Colors.yellow,
                        toolbarHeight: 50,
                        automaticallyImplyLeading: false,
                        actions: [
                          BackArrow(fromOnboarding: widget.fromOnboarding),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Human(),
                          const Title(),
                          const SubTitle(),
                          const SizedBox(height: 45,),
                          const Text1(),
                          // Expanded(
                          //   child: Container(
                          //     margin: const EdgeInsets.all(15),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white24,
                          //         borderRadius: BorderRadius.circular(8)),
                          //     child: AnimatedSwitcher(
                          //       duration: const Duration(milliseconds: 300),
                          //       switchInCurve: Curves.easeIn,
                          //       switchOutCurve: Curves.easeOut,
                          //       reverseDuration:
                          //           const Duration(milliseconds: 300),
                          //       transitionBuilder: (child, animation) {
                          //         return FadeTransition(
                          //           opacity: animation,
                          //           child: child,
                          //         );
                          //       },
                          //       child: Container(
                          //         key: Key(selectedSubscriptionIndex == 1
                          //             ? 'week'
                          //             : 'year'),
                          //         child: Builder(
                          //           builder: (context) {
                          //             if (selectedSubscriptionIndex == 1) {
                          //               return CustomPaint(
                          //                 painter:
                          //                     PainterRight(headerH: headerH),
                          //                 child: LayoutBuilder(
                          //                   builder: (context, constraints) {
                          //                     return SizedBox(
                          //                       width: double.infinity,
                          //                       height: constraints.maxHeight,
                          //                       child: Column(
                          //                         children: [
                          //                           SizedBox(
                          //                             height: constraints
                          //                                     .maxHeight *
                          //                                 headerH,
                          //                             child: Row(
                          //                               children: [
                          //                                 WeekTitle(
                          //                                     onSelectSubscription:
                          //                                         onSelectSubscription),
                          //                                 YearTitle(
                          //                                     onSelectSubscription:
                          //                                         onSelectSubscription)
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           SubscriptionBodyYear(
                          //                               package: annualPackage)
                          //                         ],
                          //                       ),
                          //                     );
                          //                   },
                          //                 ),
                          //               );
                          //             } else {
                          //               return CustomPaint(
                          //                 painter:
                          //                     PainterLeft(headerH: headerH),
                          //                 child: LayoutBuilder(
                          //                   builder: (context, constraints) {
                          //                     return SizedBox(
                          //                       width: double.infinity,
                          //                       height: constraints.maxHeight,
                          //                       child: Column(
                          //                         children: [
                          //                           SizedBox(
                          //                             height: constraints
                          //                                     .maxHeight *
                          //                                 headerH,
                          //                             child: Row(
                          //                               children: [
                          //                                 WeekTitle(
                          //                                     onSelectSubscription:
                          //                                         onSelectSubscription),
                          //                                 YearTitle(
                          //                                     onSelectSubscription:
                          //                                         onSelectSubscription)
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           SubscriptionBodyMonth(
                          //                             package: monthlyPackage,
                          //                           )
                          //                         ],
                          //                       ),
                          //                     );
                          //                   },
                          //                 ),
                          //               );
                          //             }
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          //const TermsRestorePrivacy()
                          const SizedBox(height: 15,),
                          PricesBloc(packages: packages, selectedSubscriptionIndex: selectedSubscriptionIndex, onSelectSubscription: onSelectSubscription),
                          const SizedBox(height: 20,),
                          SubscribeButton(package: packages[selectedSubscriptionIndex],)
                        ],
                      ),
                      
                      // floatingActionButtonLocation:
                      // FloatingActionButtonLocation.centerDocked,
                      // floatingActionButton: GestureDetector(
                      //   onTap: () { context
                      //     .read<SubscriptionsBloc>()
                      //     .add(MakePurchase(context: context, product: annualPackage));},
                      //   child: Container(
                      //     height: 50,
                      //     margin: const EdgeInsets.all(15),
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     decoration: BoxDecoration(
                      //         color: const Color.fromRGBO(31, 188, 183, 1),
                      //         borderRadius: BorderRadius.circular(8)),
                      //     alignment: Alignment.center,
                      //     child: const Text(
                      //       'Go Premium',
                      //       style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w700,
                      //           color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ),
                // Animate(effects: const [
                //   MoveEffect(
                //       begin: Offset(100, 0),
                //       end: Offset(0, 0),
                //       delay: Duration(milliseconds: 200)),
                // ], child: const HappyBox())
              ],
            );
          },
        );
      },
    );
  }
}

class WeekTitle extends StatelessWidget {
  final Function({required int index}) onSelectSubscription;
  const WeekTitle({super.key, required this.onSelectSubscription});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onSelectSubscription(index: 0),
      child: Center(
        child: Text(
          'Pay weekly',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ));
  }
}

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
            'Pay annually',
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
              // gradient: const LinearGradient(colors: [
              //   Color.fromRGBO(255, 238, 90, 1),
              //   Color.fromRGBO(255, 208, 74, 1),
              // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            ),
            child: Text('Save up to 29\$',
                style: Theme.of(context).textTheme.bodySmall!
                // .copyWith(color: Colors.black),
                ),
          )
        ],
      ),
    ));
  }
}

class Human extends StatelessWidget {
  const Human({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child:  Padding(
        //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Image.asset(
                Assets.subscriptionWoman.path,
                width: 200,
                height: 200,
              ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Need more summaries?',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, height: 1),
        ),
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Text(
          'Maximize your productivity and efficienty!',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1),
        ),
      ),
    );
  }
}

class Text1 extends StatelessWidget {
  const Text1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            '15 Deep Summaries Daily',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1),
          ),
        ),
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
            backgroundColor: MaterialStatePropertyAll(Colors.white)),
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
      if (fromOnboarding == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
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
    return Row(
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
          isSelected: selectedSubscriptionIndex == 2,
          package: packages[2],
          index: 2,
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
      case 'SummifyPremiumWeekly' || 'summify_premium_week':
        subscriptionTitle = '1 \nweek';
      case 'SummifyPremiumMonth' || 'summify_premium_month':
        subscriptionTitle = '1 \nmonth';
      case 'SummifyPremiumYear' || 'summify_premium_year':
        subscriptionTitle = '12 \nmonths';
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
        height: 140,
        child: GestureDetector(
          onTap: () => onSelectSubscription(index: index),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white12,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2)),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      subscriptionTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      package.storeProduct.priceString,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400),
                    ),
                    Text(
                      '${currency(code: package.storeProduct.currencyCode)} ${(package.storeProduct.price * 2).toStringAsFixed(2)}',
                      style: TextStyle(
                          color: textColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
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
    void onPressGoPremium() {
      if (widget.package != null) {
        context
            .read<SubscriptionsBloc>()
            .add(MakePurchase(context: context, product: widget.package!));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: onPressGoPremium,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
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
