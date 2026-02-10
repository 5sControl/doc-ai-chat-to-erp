import 'package:flutter/material.dart';

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
    return Dialog(
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
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Got it'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                    child: const Text('Try again'),
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
