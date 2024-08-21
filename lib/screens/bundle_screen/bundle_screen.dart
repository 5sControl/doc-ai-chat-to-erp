import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/bloc/offers/offers_state.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/bundle_screen/bundle_offer_screen.dart';
import 'package:summify/screens/modal_screens/purchase_success_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';
import '../summary_screen/info_modal/extension_modal.dart';

class BundleScreen extends StatefulWidget {
  final bool? fromOnboarding;
  final String triggerScreen;
  final bool? fromSettings;
  final bool? fromSummary;
  const BundleScreen(
      {super.key,
      this.fromOnboarding,
      required this.triggerScreen,
      this.fromSettings,
      this.fromSummary});

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
              return state is SubscriptionsStateLoading
                  ? const CircularProgressIndicator()
                  : Stack(
                      children: [
                        const BackgroundGradient(),
                        Animate(
                          effects: const [FadeEffect()],
                          child: SafeArea(
                            child: Scaffold(
                              appBar: AppBar(
                                toolbarHeight: 10,
                                bottom: PreferredSize(
                                  preferredSize: const Size.fromHeight(70.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Centered TabBar
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          padding: const EdgeInsets.all(1.5),
                                          height: 40,
                                          width: 240,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            labelColor: Colors.white,
                                            automaticIndicatorColorAdjustment:
                                                false,
                                            mouseCursor: null,
                                            overlayColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.transparent),
                                            enableFeedback: false,
                                            padding: EdgeInsets.zero,
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            unselectedLabelColor: Colors.black,
                                            dividerColor: Colors.transparent,
                                            indicatorSize:
                                                TabBarIndicatorSize.tab,
                                            tabAlignment: TabAlignment.fill,
                                            indicator: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 186, 195, 1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
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
                                      Positioned(
                                        right: 14,
                                        top: 16,
                                        bottom: 16,
                                        child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color!,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: BackArrow(
                                              fromOnboarding:
                                                  widget.fromOnboarding,
                                              fromSummary: widget.fromSummary,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              body: TabBarView(
                                controller: _tabController,
                                children: [
                                  BundleScreen1(
                                      fromOnboarding: widget.fromOnboarding,
                                      packages: packages,
                                      selectedSubscriptionIndex:
                                          selectedSubscriptionIndex,
                                      onSelectSubscription:
                                          onSelectSubscription),
                                  const SubscriptionScreenLimit(
                                    triggerScreen: 'Home',
                                    fromSettings: false,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            });
          },
        );
      },
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
  final bool? fromSummary;
  const BackArrow({super.key, this.fromOnboarding, this.fromSummary});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      if (fromOnboarding != null) {
        Navigator.of(context).pushNamed('/login');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else if (fromSummary == true) {
        Navigator.of(context).pushNamed('/');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
    }

    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPressClose,
      iconSize: 22, // Size of the icon
      icon: Icon(
        Icons.close,
        size: 18,
        color: Theme.of(context).iconTheme.color,
      ),
      padding: EdgeInsets.zero, // Remove padding to ensure circular shape
      constraints: BoxConstraints(), // Remove default constraints
      splashRadius: 18, // Match splash radius to the circle
    );
  }
}
