import 'package:flutter/material.dart';
import 'package:summify/widgets/themed_alert_dialog.dart';

void showSystemDialog({required BuildContext context, required String title}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AppThemedAlertDialog.build(
      context: ctx,
      title: AppThemedAlertDialog.titleText(ctx, title),
      actions: [
        AppThemedAlertDialog.primaryFilled(
          context: ctx,
          label: MaterialLocalizations.of(ctx).okButtonLabel,
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    ),
  );
}
