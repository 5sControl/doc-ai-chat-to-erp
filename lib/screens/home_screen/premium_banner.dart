import 'package:flutter/material.dart';
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
          return const SubscriptionScreen();
        },
      );
    }

    return InkWell(
      onTap: onPressPremiumBanner,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  Text(
                    'Get 15 Summaries Daily',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
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
      ),
    );
  }
}
