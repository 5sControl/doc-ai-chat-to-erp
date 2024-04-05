import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:summify/bloc/subscription/subscription_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/mixpanel/mixpanel_bloc.dart';
import '../bloc/settings/settings_bloc.dart';
import '../models/models.dart';

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
    final abTest = context.read<SettingsBloc>().state.abTest;

    void onPressClose() {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      context.read<MixpanelBloc>().add(const ClosePaywall());
    }

    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state.subscriptionsStatus == SubscriptionsStatus.subscribed) {
          onPressClose();
        }
      },
      builder: (context, state) {
        // final abTest = context.read<SettingsBloc>().state.abTest;
        return BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return Stack(
              children: [
                const BackgroundGradient(),
                Animate(
                  effects: const [FadeEffect()],
                  child: SafeArea(
                    child: Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        flexibleSpace: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: onPressClose,
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.all(2)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        const Color.fromRGBO(4, 49, 57, 1)
                                            .withOpacity(0.1))),
                                highlightColor:
                                    const Color.fromRGBO(4, 49, 57, 1)
                                        .withOpacity(0.2),
                                icon: const Icon(
                                  Icons.close,
                                  color: Color.fromRGBO(4, 49, 57, 1),
                                )),
                          ],
                        ),
                      ),
                      body: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio:
                                  MediaQuery.of(context).size.height < 700
                                      ? 2
                                      : 1.5,
                              child: Image.asset(
                                abTest == "A"
                                    ? Assets.girl.path
                                    : Assets.niga.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Spacer(),
                                  const Text('Need more summaries?',
                                      style: TextStyle(
                                          fontSize: 46,
                                          fontWeight: FontWeight.w700,
                                          height: 1)),
                                  const Spacer(),
                                  const Text(
                                      'Maximize your productivity \nand efficiency! ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4)),
                                  const Spacer(),
                                  const Text('15 Summaries Daily',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        height: 1,
                                      )),
                                  const Spacer(),
                                  PricesBloc(
                                      products: state.availableProducts,
                                      selectedSubscriptionIndex:
                                          selectedSubscriptionIndex,
                                      onSelectSubscription:
                                          onSelectSubscription),
                                ],
                              ),
                            )),
                            SubscribeButton(
                              product: state
                                  .availableProducts[selectedSubscriptionIndex],
                            ),
                            const TermsRestorePrivacy(),
                          ],
                        ),
                      ),
                    ),
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

class PricesBloc extends StatelessWidget {
  final int selectedSubscriptionIndex;
  final List<StoreProduct> products;
  final Function({required int index}) onSelectSubscription;
  const PricesBloc(
      {super.key,
      required this.products,
      required this.selectedSubscriptionIndex,
      required this.onSelectSubscription});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SubscriptionCover(
          onSelectSubscription: onSelectSubscription,
          isSelected: selectedSubscriptionIndex == 0,
          subscription: products[0],
          index: 0,
        ),
        const SizedBox(
          width: 5,
        ),
        SubscriptionCover(
          onSelectSubscription: onSelectSubscription,
          isSelected: selectedSubscriptionIndex == 1,
          subscription: products[1],
          index: 1,
        ),
        const SizedBox(
          width: 5,
        ),
        SubscriptionCover(
          onSelectSubscription: onSelectSubscription,
          isSelected: selectedSubscriptionIndex == 2,
          subscription: products[2],
          index: 2,
        ),
      ],
    );
  }
}

class SubscriptionCover extends StatelessWidget {
  final bool isSelected;
  final StoreProduct subscription;
  final Function({required int index}) onSelectSubscription;
  final int index;
  const SubscriptionCover(
      {super.key,
      required this.subscription,
      required this.isSelected,
      required this.onSelectSubscription,
      required this.index});

  @override
  Widget build(BuildContext context) {
    String subscriptionTitle = '';
    switch (subscription.id) {
      case 'SummifyPremiumWeekly':
        subscriptionTitle = '1 \nweek';
      case 'SummifyPremiumMonth':
        subscriptionTitle = '1 \nmonth';
      case 'SummifyPremiumYear':
        subscriptionTitle = '12 \nmonths';
    }

    return Expanded(
      child: SizedBox(
        height: 140,
        child: GestureDetector(
          onTap: () => onSelectSubscription(index: index),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(31, 188, 183, 1)
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
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      subscription.price,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 24,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400),
                    ),
                    Text(
                      subscription.currencySymbol +
                          (subscription.rawPrice * 2 + 0.01)
                              .toStringAsFixed(2)
                              .toString(),
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          decoration: TextDecoration.lineThrough,
                          decorationColor:
                              isSelected ? Colors.white : Colors.black,
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

class SubscribeButton extends StatefulWidget {
  final StoreProduct? product;
  const SubscribeButton({super.key, required this.product});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool tapped = false;

  static const duration = Duration(milliseconds: 150);
  void onTapDown() {
    setState(() {
      tapped = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        tapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onPressGoPremium() {
      if (widget.product != null) {
        context
            .read<SubscriptionBloc>()
            .add(BuySubscription(subscriptionId: widget.product!.id));
      }
    }

    return GestureDetector(
        onTap: onPressGoPremium,
        onTapUp: (_) => onTapUp(),
        onTapDown: (_) => onTapDown(),
        onTapCancel: () => onTapUp(),
        child: AnimatedScale(
          duration: duration,
          scale: tapped ? 0.95 : 1,
          child: AnimatedContainer(
            duration: duration,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: !tapped
                  ? const Color.fromRGBO(31, 188, 183, 1)
                  : const Color.fromRGBO(4, 49, 57, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

class TermsRestorePrivacy extends StatelessWidget {
  const TermsRestorePrivacy({super.key});

  void onPressTerms() async {
    final Uri url = Uri.parse(
        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
    if (!await launchUrl(url)) {}
  }

  void onPressRestore() async {
    await InAppPurchase.instance.restorePurchases();
  }

  void onPressPrivacy() async {
    final Uri url = Uri.parse('https://elang.app/privacy');
    if (!await launchUrl(url)) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onPressTerms,
            child: const Text(
              'Terms of use',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onPressRestore,
            child: const Text(
              'Restore purchase',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onPressPrivacy,
            child: const Text(
              'Privacy policy',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
