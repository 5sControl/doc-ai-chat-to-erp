import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/bloc/offers/offers_event.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';

import '../../gen/assets.gen.dart';
import '../subscribtions_screen/subscriptions_screen.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressPremiumBanner() {
      context.read<OffersBloc>().add(NextScreenEvent());
      // showCupertinoModalBottomSheet(
      //   context: context,
      //   expand: false,
      //   bounce: false,
      //   barrierColor: Colors.black54,
      //   backgroundColor: Colors.transparent,
      //   builder: (context) {
      //     return const BundleScreen(
      //       fromOnboarding: true,
      //       triggerScreen: 'Home',
      //     );
      //   },
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const BundleScreen(
                  triggerScreen: 'Home',
                )),
      );
    }

    return InkWell(
      onTap: onPressPremiumBanner,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(255, 238, 90, 1),
              Color.fromRGBO(255, 208, 74, 1)
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
                    'Break free from limits! ',
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
                        const TextSpan(text: '2 apps for free! '),
                        // WidgetSpan(
                        //     child: DecoratedBox(
                        //       decoration: const BoxDecoration(boxShadow: [
                        //         BoxShadow(color: Colors.black12, blurRadius: 5)
                        //       ]),
                        //       child: SvgPicture.asset(
                        //         Assets.icons.chrome,
                        //         width: 20,
                        //       ),
                        //     ),
                        //     alignment: PlaceholderAlignment.middle),
                        //const TextSpan(text: ' for free!'),
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
