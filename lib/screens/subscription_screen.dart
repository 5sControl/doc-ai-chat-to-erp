import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/mixpanel/mixpanel_bloc.dart';
import '../bloc/subscriptions/subscriptions_bloc.dart';
import 'modal_screens/purchase_success_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var selectedSubscriptionIndex = 1;

  void onSelectSubscription({required int index}) {
    setState(() {
      selectedSubscriptionIndex = index;
    });
  }

  @override
  void initState() {
    context.read<MixpanelBloc>().add(const PaywallShow(trigger: 'settings'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      Navigator.of(context).pop();
      context.read<MixpanelBloc>().add(const ClosePaywall());
    }

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
      // listenWhen: (previous, current) =>
      //     previous.transactionStatus == TransactionStatus.idle &&
      //     current.transactionStatus == TransactionStatus.complete,
      listener: (context, state) {
        // onSubscriptionsComplete();
      },
      builder: (context, state) {
        final abTest = context.read<SettingsBloc>().state.abTest;

        return Stack(
          children: [
            const BackgroundGradient(),
            Animate(
              effects: const [FadeEffect()],
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
                                  Colors.white.withOpacity(0.1))),
                          highlightColor: Colors.white.withOpacity(0.2),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            MediaQuery.of(context).size.height < 700 ? 2 : 1.5,
                        child: Image.asset(
                          abTest == "B" ? Assets.girl.path : Assets.niga.path,
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
                            Spacer(),
                            const Text('Need more summaries?',
                                style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w700,
                                    height: 1)),
                            // const Divider(
                            //   color: Colors.transparent,
                            //   height: 25,
                            // ),
                            Spacer(),
                            const Text(
                                'Maximize your productivity \nand efficiency! ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4)),
                            // const Divider(
                            //   color: Colors.transparent,
                            //   height: 20,
                            // ),
                            Spacer(),
                            const Text('15 Summaries Daily',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                )),
                            Spacer(),
                            // PricesBloc(
                            //     products: state.availableProducts,
                            //     selectedSubscriptionIndex:
                            //         selectedSubscriptionIndex,
                            //     onSelectSubscription: onSelectSubscription),
                            Spacer(),
                            if (Platform.isAndroid)
                              Text(
                                'Cancel subscription anytime in Google Play settings',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              )
                          ],
                        ),
                      )),
                      // SubscribeButton(
                      //   product:
                      //       state.availableProducts[selectedSubscriptionIndex],
                      // ),
                      const TermsRestorePrivacy(),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    // String subscriptionTitle = '';
    // switch (subscription.id) {
    //   case 'SummifyPremiumWeekly' || 'summify_premium_week':
    //     subscriptionTitle = '1 \nweek';
    //   case 'SummifyPremiumMonth' || 'summify_premium_month':
    //     subscriptionTitle = '1 \nmonth';
    //   case 'SummifyPremiumYear' || 'summify_premium_year':
    //     subscriptionTitle = '12 \nmonths';
    // }
    //
    // final textColor = Theme.of(context).brightness == Brightness.light
    //     ? isSelected
    //         ? Colors.white
    //         : Colors.black
    //     : Colors.white;

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
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Text(
                //       subscriptionTitle,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //           color: textColor,
                //           fontSize: 13,
                //           fontWeight: FontWeight.w500),
                //     ),
                //     const Divider(
                //       color: Colors.transparent,
                //     ),
                //     Text(
                //       '${subscription.currencySymbol}${subscription.rawPrice}',
                //       textAlign: TextAlign.center,
                //       overflow: TextOverflow.clip,
                //       style: TextStyle(
                //           color: textColor,
                //           fontSize: 18,
                //           fontWeight:
                //               isSelected ? FontWeight.w700 : FontWeight.w400),
                //     ),
                //     Text(
                //       subscription.currencySymbol +
                //           (subscription.rawPrice * 2 + 0.01)
                //               .toStringAsFixed(2)
                //               .toString(),
                //       style: TextStyle(
                //           color: textColor,
                //           decoration: TextDecoration.lineThrough,
                //           decorationColor: Colors.white,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w400),
                //     ),
                //   ],
                // ),
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
  @override
  Widget build(BuildContext context) {
    void onPressGoPremium() {
      if (widget.product != null) {
        // context
        //     .read<SubscriptionsBloc>()
        //     .add(BuySubscription(subscriptionId: widget.product!.id));
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
              'Submit',
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

class TermsRestorePrivacy extends StatelessWidget {
  const TermsRestorePrivacy({super.key});

  void onPressTerms() async {
    final Uri url = Uri.parse(
        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
    if (!await launchUrl(url)) {}
  }

  void onPressRestore() async {
    // await InAppPurchase.instance.restorePurchases();
  }

  void onPressPrivacy() async {
    final Uri url = Uri.parse('https://elang.app/privacy');
    if (!await launchUrl(url)) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Platform.isIOS)
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
        if (Platform.isIOS)
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
