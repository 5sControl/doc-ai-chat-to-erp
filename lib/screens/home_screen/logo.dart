import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.icons.logo,
          height: 17,
          width: 17,
          colorFilter: ColorFilter.mode(
              Theme.of(context).cardColor, BlendMode.srcIn),
        ),
        Text(
          ' LM Notebook Pro',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}