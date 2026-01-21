import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

class SettingsButton extends StatelessWidget {
  final Function() onPressSettings;
  const SettingsButton({super.key, required this.onPressSettings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: 35,
      height: 35,
      child: IconButton(
        onPressed: onPressSettings,
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset(
          Assets.icons.profileCircle,
          height: 35,
          width: 35,
          colorFilter: ColorFilter.mode(
              Theme.of(context).cardColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}