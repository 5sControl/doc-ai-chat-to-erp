import 'package:flutter/material.dart';

import '../../widgets/backgroung_gradient.dart';

/// Общий layout для экранов настроек: фон приложения + Scaffold с прозрачным AppBar.
/// Используется на корневом экране настроек и на экранах групп, чтобы стиль был единым.
class SettingsScreenLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const SettingsScreenLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text(title),
          ),
          body: body,
        ),
      ],
    );
  }
}
