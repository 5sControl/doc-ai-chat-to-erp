import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../gen/assets.gen.dart';
import '../subscribtions_screen/subscriptions_screen.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressPremiumBanner() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const SubscriptionScreen(
            fromOnboarding: true,
          );
        },
      );
    }

    return InkWell(
      onTap: onPressPremiumBanner,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(254, 205, 103, 1),
              Color.fromRGBO(251, 171, 14, 1)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset(
                Assets.icons.crown,
                width: 32,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Become Super Premium',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14),
                          children: [
                        const TextSpan(text: 'Get on '),
                        WidgetSpan(
                            child: DecoratedBox(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                              child: SvgPicture.asset(
                                Assets.icons.chrome,
                                width: 20,
                              ),
                            ),
                            alignment: PlaceholderAlignment.middle),
                        const TextSpan(text: ' for free!'),
                      ]))
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black,
            )
          ],
        ),
      )
          .animate(
            autoPlay: true,
            onPlay: (controller) => controller.repeat(),
          )
          .shimmer(
              color: Colors.white.withOpacity(0.75),
              duration: const Duration(milliseconds: 1500),
              delay: const Duration(seconds: 1)),
    );
  }
}
