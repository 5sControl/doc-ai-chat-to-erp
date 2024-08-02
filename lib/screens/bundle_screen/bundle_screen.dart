import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/modal_screens/purchase_success_screen.dart';
import 'package:summify/screens/subscribtions_screen/happy_box.dart';
import 'package:summify/screens/subscribtions_screen/subscription_body_month.dart';
import 'package:summify/screens/subscribtions_screen/subscription_body_year.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/screens/subscribtions_screen/terms_restore_privacy.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../summary_screen/info_modal/extension_modal.dart';

class BundleScreen extends StatefulWidget {
  final bool? fromOnboarding;
  final String triggerScreen;
  const BundleScreen(
      {super.key, this.fromOnboarding, required this.triggerScreen});

  @override
  State<BundleScreen> createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

        final monthlyPackage = packages
            .firstWhere((element) => element.packageType == PackageType.weekly);
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
                         toolbarHeight: 10,
                        // automaticallyImplyLeading: false,
                        // title: SwitcherWidget(),
                        // centerTitle: true,
                        bottom: TabBar(
                          padding: EdgeInsets.only(left: 65, right: 65),
                          controller: _tabController,
                          tabs: [
                            Tab(
                              text: 'Bundle',
                            ),
                            Tab(
                              text: 'Unlimited',
                            )
                          ],
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          color: Colors.teal.shade300,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                          labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                        // actions: [
                        //   BackArrow(fromOnboarding: widget.fromOnboarding),
                        //   const SizedBox(
                        //     width: 10,
                        //   )
                        // ],
                      ),
                      //body: BundleScreen1(packages: packages, selectedSubscriptionIndex: selectedSubscriptionIndex),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          BundleScreen1(
                              packages: packages,
                              selectedSubscriptionIndex:
                                  selectedSubscriptionIndex),
                          SubscriptionScreen(triggerScreen: '')
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50, right: 10,
                  child: BackArrow(fromOnboarding: widget.fromOnboarding),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class BundleScreen1 extends StatelessWidget {
  const BundleScreen1({
    super.key,
    required this.packages,
    required this.selectedSubscriptionIndex,
  });

  final List<Package> packages;
  final int selectedSubscriptionIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Title(),
        Body(),
        SizedBox(
          height: 15,
        ),
        Body1(),
        SizedBox(
          height: 15,
        ),
        //PricesBloc(packages: packages, selectedSubscriptionIndex: selectedSubscriptionIndex, onSelectSubscription: onSelectSubscription,),
        SubscribeButton(
          package: packages[selectedSubscriptionIndex],
        ),

        TermsRestorePrivacy()
      ],
    );
  }
}

class SwitcherWidget extends StatefulWidget {
  @override
  _SwitcherWidgetState createState() => _SwitcherWidgetState();
}

class _SwitcherWidgetState extends State<SwitcherWidget> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(8),
        borderColor: Colors.transparent,
        fillColor: Colors.teal.shade300,
        selectedColor: Colors.white,
        color: Colors.black,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Bundle'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Unlimited'),
          ),
        ],
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              'BUY',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.transcriptor1,
                  ),
                  Text(
                    'Transcriptor',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Text('+',
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.w600)),
              SizedBox(
                width: 35,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.summafyMini,
                    height: 75,
                  ),
                  Text(
                    'Summify',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Body1 extends StatelessWidget {
  const Body1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      color: Colors.white.withOpacity(0.5),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'GET FOR FREE',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.transcriptor2,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Transcriptor',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Text('+',
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.w600)),
              SizedBox(
                width: 35,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.logo,
                    height: 75,
                    color: Colors.black87,
                  ),
                  Text(
                    'Summify',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'on',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                Assets.icons.chrome,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Version',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              )
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
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
    void onPressGoPremium() {
      if (widget.package != null) {
        context
            .read<SubscriptionsBloc>()
            .add(MakePurchase(context: context, product: widget.package!));
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: Colors.white24,
          borderRadius: BorderRadius.circular(8),
          onTap: onPressGoPremium,
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

class Title extends StatefulWidget {
  const Title({super.key});

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  final List<List<String>> wordPairs = [
    ['Unlock Limitless', 'Possibilities'],
    ['Endless Possibilities', 'with 50% Off'],
    ['Unlock the Power', 'of Unlimited'],
  ];

  List<String> displayedPair = ["", ""];

  List<String> getRandomPair() {
    final random = Random();
    int index = random.nextInt(wordPairs.length);
    return wordPairs[index];
  }

  @override
  void initState() {
    super.initState();
    displayedPair = getRandomPair();
  }

  void refreshPair() {
    setState(() {
      displayedPair = getRandomPair();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: '${displayedPair[0]}\n',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                ),
          ),
          TextSpan(
              text: '${displayedPair[1]}',
              style: TextStyle(
                fontSize: 28,
                color: displayedPair[1] == 'with 50% Off'
                    ? Colors.teal
                    : Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ))
        ]),
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
            minimumSize: MaterialStateProperty.all<Size>(Size(35, 35)),
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
