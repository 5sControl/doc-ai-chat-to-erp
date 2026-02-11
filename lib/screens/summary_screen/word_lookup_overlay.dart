import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/word_translate_service.dart';

/// Remove callback for the currently shown word lookup overlay. Only one overlay at a time.
void Function()? _removeCurrentWordLookup;

/// Long text threshold: no auto-dismiss timer, user closes manually.
const int _longTextLengthThreshold = 100;

/// Shows the word lookup as a system overlay (above the route, does not affect layout).
/// Fetches translation, updates the overlay, auto-dismisses after [duration] unless text length > [_longTextLengthThreshold].
/// Only one overlay is shown at a time; showing a new one removes the previous.
void showWordLookupOverlay(
  BuildContext context, {
  required String word,
  required String targetLang,
  Duration duration = WordLookupOverlay.defaultDuration,
  void Function(String word)? onSpeakWord,
}) {
  _removeCurrentWordLookup?.call();
  _removeCurrentWordLookup = null;

  final overlay = Overlay.of(context);
  final state = ValueNotifier<_LookupState>(
    _LookupState(word: word, result: null, loading: true),
  );
  OverlayEntry? entry;
  Timer? dismissTimer;

  void remove() {
    dismissTimer?.cancel();
    entry?.remove();
    entry = null;
    if (_removeCurrentWordLookup == remove) {
      _removeCurrentWordLookup = null;
    }
  }

  entry = OverlayEntry(
    builder: (ctx) {
      return Positioned(
        top: MediaQuery.of(ctx).padding.top + 8,
        left: 16,
        right: 16,
        child: ListenableBuilder(
          listenable: state,
          builder: (_, __) {
            final s = state.value;
            return WordLookupOverlay(
              word: s.word,
              result: s.result,
              isLoading: s.loading,
              onDismiss: remove,
            );
          },
        ),
      );
    },
  );
  overlay.insert(entry!);
  _removeCurrentWordLookup = remove;

  WordTranslateService.instance.lookup(word, targetLang).then((result) {
    if (entry == null) return;
    state.value = _LookupState(word: word, result: result, loading: false);
    if (word.length <= _longTextLengthThreshold) {
      dismissTimer = Timer(duration, remove);
    }
    if (!result.isError && onSpeakWord != null) {
      onSpeakWord(word);
    }
  });
}

class _LookupState {
  final String word;
  final WordLookupResult? result;
  final bool loading;
  _LookupState({required this.word, this.result, required this.loading});
}

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

  static const Duration defaultDuration = Duration(seconds: 5);

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
