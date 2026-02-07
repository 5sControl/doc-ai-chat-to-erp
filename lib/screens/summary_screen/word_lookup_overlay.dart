import 'package:flutter/material.dart';

import '../../services/word_translate_service.dart';

/// Compact overlay showing word + translation (or loading/error). Auto-hides after [duration].
class WordLookupOverlay extends StatelessWidget {
  final String word;
  final WordLookupResult? result;
  final bool isLoading;
  final VoidCallback? onDismiss;

  const WordLookupOverlay({
    super.key,
    required this.word,
    this.result,
    this.isLoading = false,
    this.onDismiss,
  });

  static const Duration defaultDuration = Duration(seconds: 3);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isLoading)
                    Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '…',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    )
                  else if (result != null)
                    Text(
                      result!.isError
                          ? (result!.errorMessage ?? 'Error')
                          : result!.translation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: result!.isError
                            ? theme.colorScheme.error
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
      ),
    );
  }
}
