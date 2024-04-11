import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../widgets/premium_banner.dart';

// class ButtonItem {
//   final String title;
//   final Widget icon;
//   final Function onTap;
//   const ButtonItem(
//       {required this.title, required this.icon, required this.onTap});
// }

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Column(
                children: [PremiumBanner(), GeneralGroup(), ManageGroup(), OtherGroup()],
              )),
        ),
      ],
    );
  }
}

class GeneralGroup extends StatelessWidget {
  const GeneralGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'General',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(30, 188, 183, 1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SvgPicture.asset(Assets.icons.notification),
              ),
              const Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    'Notification',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )),
              SizedBox(
                height: 20,
                child: Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.teal.shade900,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class ManageGroup extends StatelessWidget {
  const ManageGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'Manage',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(30, 188, 183, 1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SvgPicture.asset(
                  Assets.icons.crown,
                  height: 20,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              const Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    'Subscription',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ))
            ],
          ),
        )
      ],
    );
  }
}

class OtherGroup extends StatelessWidget {
  const OtherGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 2),
          child: Text(
            'Other',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(30, 188, 183, 1),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(
                      Assets.icons.phone,
                      height: 20,
                      colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'Our apps',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
              const Divider(color: Colors.white,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(
                      Assets.icons.star,
                      height: 20,
                      colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'Rate app',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
              const Divider(color: Colors.white,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(
                      Assets.icons.chat,
                      height: 20,
                      colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'Leave feedback',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
              const Divider(color: Colors.white,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(
                      Assets.icons.phone,
                      height: 20,
                      colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        'Credits',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
            ],
          )
        )
      ],
    );
  }
}