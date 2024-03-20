import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/screens/modal_screens/how_to_screen.dart';
import 'package:summify/screens/subscription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/modal_handle.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressTerms() async {
      final Uri url = Uri.parse(
          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
      if (!await launchUrl(url)) {}
    }

    void onPressPrivacy() async {
      final Uri url = Uri.parse('https://elang.app/privacy');
      if (!await launchUrl(url)) {}
    }

    void onPressHowTo() async {
      Navigator.of(context).pop();
      Future.delayed(const Duration(milliseconds: 300), () {
        showMaterialModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const HowToScreen();
          },
        );
      });
    }

    void onPressPremium() {
      Navigator.of(context).pop();
      Future.delayed(const Duration(milliseconds: 10), () {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          // enableDrag: false,
          builder: (context) {
            return const SubscriptionScreen();
          },
        );
      });
    }

    return Material(
      color: const Color.fromRGBO(227, 255, 254, 1),
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ModalHandle(),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(30, 188, 183, 0.8),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  InkWell(
                    onTap: onPressPremium,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Premium',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: onPressHowTo,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'How to setup share button',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: onPressTerms,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terms of use',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: onPressPrivacy,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Privacy policy',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
