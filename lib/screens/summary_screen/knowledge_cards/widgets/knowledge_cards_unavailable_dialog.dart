import 'package:flutter/material.dart';
import 'package:summify/widgets/themed_alert_dialog.dart';

import 'unsupported_device_placeholder.dart';

/// Dialog shown when knowledge cards extraction failed (e.g. server error).
/// Uses [UnsupportedDevicePlaceholder] as content, with Try again and Got it actions.
class KnowledgeCardsUnavailableDialog extends StatelessWidget {
  const KnowledgeCardsUnavailableDialog({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  static Future<void> show(BuildContext context, VoidCallback onRetry) {
    return showDialog<void>(
      context: context,
      builder: (context) => KnowledgeCardsUnavailableDialog(onRetry: onRetry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: AppThemedAlertDialog.shapeOf(theme),
      backgroundColor: AppThemedAlertDialog.backgroundColor(theme),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: const UnsupportedDevicePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppThemedAlertDialog.secondaryAction(
                    context: context,
                    label: 'Got it',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  AppThemedAlertDialog.primaryFilled(
                    context: context,
                    label: 'Try again',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
