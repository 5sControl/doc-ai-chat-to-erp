import 'package:flutter/material.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      // context.read<SharedLinksBloc>().add(RateSummary(sharedLink: summaryLink));
      Navigator.of(context).pop();
    }

    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
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
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(2)),
                        backgroundColor: MaterialStatePropertyAll(
                            const Color.fromRGBO(4, 49, 57, 1)
                                .withOpacity(0.1))),
                    highlightColor:
                        const Color.fromRGBO(4, 49, 57, 1).withOpacity(0.2),
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromRGBO(4, 49, 57, 1),
                    )),
              ],
            ),
          ),
          body: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  Assets.girla.path,
                  fit: BoxFit.cover,
                ),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Need more summaries?',
                          style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w700,
                              height: 1)),
                      Divider(
                        color: Colors.transparent,
                        height: 25,
                      ),
                      Text('Maximize your productivity \nand efficiency! ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.4)),
                      Divider(
                        color: Colors.transparent,
                        height: 20,
                      ),
                      PriceBloc(price: '\$1.49'),
                    ],
                  ),
                )),
                const SubscribeButton(),
                const TermsRestorePrivacy(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PriceBloc extends StatelessWidget {
  final String price;
  const PriceBloc({super.key, required this.price});

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
                color: Colors.white70, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  price,
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
          ),
        ))
      ],
    );
  }
}

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(31, 188, 183, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Go Premium',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TermsRestorePrivacy extends StatelessWidget {
  const TermsRestorePrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: Text(
          'Terms of use',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          'Restore purchase',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          'Privacy policy',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }
}
