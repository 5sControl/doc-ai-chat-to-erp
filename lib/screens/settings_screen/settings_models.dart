import 'package:flutter/material.dart';

/// Single row item for settings list (icon, title, optional trailing, onTap).
class ButtonItem {
  final String title;
  final String leadingIcon;
  final Widget? trailing;
  final Gradient? background;
  final VoidCallback onTap;

  const ButtonItem({
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    this.trailing,
    this.background,
  });
}

/// Identifies a settings group for navigation and config lookup.
enum SettingsGroupId {
  subscription,
  general,
  about,
  support,
  account,
  voice,
}

/// Arguments for the /settings/group route.
class SettingsGroupArgs {
  final SettingsGroupId id;
  final String title;

  const SettingsGroupArgs({required this.id, required this.title});
}
