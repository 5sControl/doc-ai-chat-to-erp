import 'package:flutter/material.dart';

/// Brand-styled [AlertDialog]: mint background, teal accents, black titles/body.
abstract final class AppThemedAlertDialog {
  static const double borderRadius = 16;

  static ShapeBorder shapeOf(ThemeData theme) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      );

  static Color backgroundColor(ThemeData theme) => theme.primaryColorLight;

  static TextStyle? titleTextStyle(ThemeData theme) =>
      theme.textTheme.bodyLarge?.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      );

  static TextStyle? contentTextStyle(ThemeData theme) =>
      theme.textTheme.bodyMedium?.copyWith(color: Colors.black);

  static AlertDialog build({
    required BuildContext context,
    required Widget title,
    Widget? content,
    List<Widget>? actions,
  }) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: shapeOf(theme),
      backgroundColor: backgroundColor(theme),
      title: title,
      content: content,
      actions: actions,
    );
  }

  static Widget titleText(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(text, style: titleTextStyle(theme));
  }

  static Widget contentText(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(text, style: contentTextStyle(theme));
  }

  static Widget secondaryAction({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: theme.primaryColor)),
    );
  }

  static Widget primaryFilled({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  static Widget destructiveFilled({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
