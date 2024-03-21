import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:summify/bloc/subscription/subscription_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      // context.read<SharedLinksBloc>().add(RateSummary(sharedLink: summaryLink));
      Navigator.of(context).pop();
    }

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return Stack(
          children: [
            const BackgroundGradient(),
            Animate(
              effects: [FadeEffect()],
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
                          highlightColor: const Color.fromRGBO(4, 49, 57, 1)
                              .withOpacity(0.2),
                          icon: const Icon(
                            Icons.close,
                            color: Color.fromRGBO(4, 49, 57, 1),
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
                      Image.asset(
                        Assets.girla.path,
                        fit: BoxFit.cover,
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
                            const Text('Need more summaries?',
                                style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w700,
                                    height: 1)),
                            const Divider(
                              color: Colors.transparent,
                              height: 25,
                            ),
                            const Text(
                                'Maximize your productivity \nand efficiency! ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4)),
                            const Divider(
                              color: Colors.transparent,
                              height: 20,
                            ),
                            PriceBloc(product: state.availableProducts.first),
                          ],
                        ),
                      )),
                      SubscribeButton(
                        product: state.availableProducts.first,
                      ),
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

class PriceBloc extends StatelessWidget {
  final StoreProduct? product;
  const PriceBloc({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: AspectRatio(
          aspectRatio: 1.2,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(12)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '15',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 46, fontWeight: FontWeight.w500, height: 1),
                ),
                Text(
                  'summaries daily',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w400, height: 1),
                ),
              ],
            ),
          ),
        )),
        const VerticalDivider(),
        Expanded(
            child: AspectRatio(
          aspectRatio: 1.2,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12)),
              child: AnimatedCrossFade(
                firstChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product?.price ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 46, fontWeight: FontWeight.w500, height: 1),
                    ),
                    const Text(
                      'weekly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w400, height: 1),
                    ),
                  ],
                ),
                secondChild: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                crossFadeState: product == null
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              )),
        ))
      ],
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
              'Go Premium',
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
