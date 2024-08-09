import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/modal_screens/purchase_success_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/screens/subscribtions_screen/terms_restore_privacy.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../summary_screen/info_modal/extension_modal.dart';

class BundleScreen extends StatefulWidget {
  final bool? fromOnboarding;
  final String triggerScreen;
  final bool? fromSettings;
  const BundleScreen(
      {super.key, this.fromOnboarding, required this.triggerScreen, this.fromSettings});

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

  int getSelectedTabIndex() {
    return _tabController.index;
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
        List<Package> packages = List.from(state.availableProducts!
            .all['Summify bundle access']!.availablePackages);
        packages.sort(
            (a, b) => a.storeProduct.price.compareTo(b.storeProduct.price));

        final monthlyPackage = packages.firstWhere(
            (element) => element.packageType == PackageType.monthly);
        final annualPackage = packages
            .firstWhere((element) => element.packageType == PackageType.annual);
            

        return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            return BlocBuilder<OffersBloc, OffersState>(
              builder: (context, state) {
                // final selectedIndex = getSelectedTabIndex();
                return Stack(
                  children: [
                    const BackgroundGradient(),
                    Animate(
                      effects: const [FadeEffect()],
                      child: SafeArea(
                        child: Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 10,
                            // backgroundColor:selectedIndex == 1 || (state.screenIndex == 0 || state.screenIndex == 3) ? Colors.yellow : Colors.transparent,
                            // automaticallyImplyLeading: false,
                            // title: SwitcherWidget(),
                            // centerTitle: true,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(
                                  70.0), // Adjust the height as needed
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                padding: const EdgeInsets.all(1.5),
                                height: 40,
                                width: 240,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: TabBar(
                                  controller: _tabController,
                                  // isScrollable: true,
                                  labelColor: Colors.white,
                                  automaticIndicatorColorAdjustment: false,
                                  mouseCursor: null,
                                  overlayColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  enableFeedback: false,
                                  padding: EdgeInsets.zero,
                                  splashFactory: NoSplash.splashFactory,
                                  unselectedLabelColor: Colors.black,
                                  dividerColor: Colors.transparent,
                                  // labelPadding: const EdgeInsets.symmetric(
                                  //   horizontal: 1,
                                  // ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabAlignment: TabAlignment.fill,
                                  indicator: BoxDecoration(
                                      color: const Color.fromRGBO(0, 186, 195, 1),
                                      borderRadius: BorderRadius.circular(6)),
                                  tabs: const [
                                    Tab(
                                      text: 'Bundle',
                                    ),
                                    Tab(
                                      text: 'Unlimited',
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // TabBar(
                            //   padding: EdgeInsets.only(left: 65, right: 65),
                            //   controller: _tabController,
                            //   tabs: [
                            //     Tab(
                            //       text: 'Bundle',
                            //     ),
                            //     Tab(
                            //       text: 'Unlimited',
                            //     )
                            //   ],
                            //   indicator: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(12.0),
                            //   color: Colors.teal.shade300,
                            //   ),
                            //   labelColor: Colors.white,
                            //   unselectedLabelColor:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            //   labelStyle: TextStyle(
                            //     fontSize: 16.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   unselectedLabelStyle: TextStyle(
                            //     fontSize: 16.0,
                            //   ),
                            //   labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
                            //   indicatorSize: TabBarIndicatorSize.tab,
                            // ),
                            ///////////////////////
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
                                fromOnboarding: widget.fromOnboarding,
                                  packages: packages,
                                  selectedSubscriptionIndex:
                                      selectedSubscriptionIndex,
                                  onSelectSubscription: onSelectSubscription),
                              // SubscriptionScreen(
                              //   triggerScreen: '',
                              //   showBackArrow: false,
                              // )
                              const SubscriptionScreenLimit(triggerScreen: 'Home', fromSettings: false,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 85,
                      right: 10,
                      child: BackArrow(fromOnboarding: widget.fromOnboarding),
                    ),
                  ],
                );
              }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Title(fromOnboarding: fromOnboarding,),
        SizedBox(
          height: isTablet ? 15 : 0,
        ),
        const Body(),
        SizedBox(
          height: isTablet ? 40 : 5,
        ),
        const Body1(),
        SizedBox(
          height: isTablet ? 50 : 10,
        ),
        PricesBloc(
          packages: packages,
          selectedSubscriptionIndex: selectedSubscriptionIndex,
          onSelectSubscription: onSelectSubscription,
        ),
        SizedBox(
          height: isTablet ? 20 : 0,
        ),
        SubscribeButton(
          package: packages[selectedSubscriptionIndex],
        ),
        SizedBox(
          height: isTablet ? 10 : 0,
        ),
        const TermsRestorePrivacy()
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
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Bundle'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Unlimited'),
          ),
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
    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              'BUY',
              style: TextStyle(
                  fontSize: isTablet ? 34 : 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: isTablet ? 20 : 0,
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 20 : 16),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                Assets.icons.plus,
                height: 36,
              ),
              const SizedBox(
                width: 35,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.summifyLogo,
                    height: 75,
                  ),
                  Text(
                    'Summify',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 20 : 16),
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
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Container(
      height: isTablet ? 340 : 210,
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
            height: isTablet ? 40 : 4,
          ),
          Text(
            'GET FOR FREE',
            style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 34 : 26,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: isTablet ? 20 : 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.transcriptor2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Transcriptor',
                    style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              SvgPicture.asset(
                Assets.icons.plus,
                height: 36,
              ),
              const SizedBox(
                width: 35,
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    Assets.icons.logo,
                    height: 75,
                    color: Colors.black87,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Summify',
                    style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: isTablet ? 20 : 5,
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
        color: Theme.of(context).primaryColor,
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
    ['Unlock the Power', 'of Unlimited'],
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
                fontSize: isTablet ? 56 : 28,
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
                        ? 64
                        : 36
                    : isTablet
                        ? 56
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
              const TextSpan(
                text: " FOR FREE!",
              ),
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
        Navigator.of(context).pushNamed('/login');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all<Size>(const Size(33, 33)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.black),
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
        height: 110,
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
                        padding: const EdgeInsets.all(0),
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
