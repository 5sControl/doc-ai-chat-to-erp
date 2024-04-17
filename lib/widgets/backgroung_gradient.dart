import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/main.dart';

import '../bloc/settings/settings_bloc.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Container(
            key: Key(state.appTheme.name),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(context.isDarkMode ? Assets.bgDark.path :  Assets.bgLight.path),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover)),
          ),
        );
      },
    );
  }
}
