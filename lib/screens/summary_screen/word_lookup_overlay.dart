import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/word_translate_service.dart';

/// Remove callback for the currently shown word lookup overlay. Only one overlay at a time.
void Function()? _removeCurrentWordLookup;

/// Long text threshold: no auto-dismiss timer, user closes manually.
const int _longTextLengthThreshold = 100;

/// Max words (1-3) for auto TTS playback. Longer selections (phrases/sentences) are not spoken.
const int _maxWordsForAutoSpeak = 3;

/// Shows the word lookup as a system overlay (above the route, does not affect layout).
/// Fetches translation, updates the overlay, auto-dismisses after [duration] unless text length > [_longTextLengthThreshold].
/// Only one overlay is shown at a time; showing a new one removes the previous.
void showWordLookupOverlay(
  BuildContext context, {
  required String word,
  required String targetLang,
  String? sentenceContext,
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

  void cancelTimer() {
    dismissTimer?.cancel();
    dismissTimer = null;
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
              onExpand: cancelTimer,
            );
          },
        ),
      );
    },
  );
  overlay.insert(entry!);
  _removeCurrentWordLookup = remove;

  WordTranslateService.instance
      .lookup(word, targetLang, sentenceContext: sentenceContext)
      .then((result) {
    if (entry == null) return;
    state.value = _LookupState(word: word, result: result, loading: false);
    if (word.length <= _longTextLengthThreshold) {
      dismissTimer = Timer(duration, remove);
    }
    final wordCount = word.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    if (!result.isError && onSpeakWord != null && wordCount >= 1 && wordCount <= _maxWordsForAutoSpeak) {
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

/// Compact overlay showing word + translation + optional transcription + expandable context note.
class WordLookupOverlay extends StatefulWidget {
  final String word;
  final WordLookupResult? result;
  final bool isLoading;
  final VoidCallback? onDismiss;
  final VoidCallback? onExpand;

  const WordLookupOverlay({
    super.key,
    required this.word,
    this.result,
    this.isLoading = false,
    this.onDismiss,
    this.onExpand,
  });

  static const Duration defaultDuration = Duration(seconds: 5);

  @override
  State<WordLookupOverlay> createState() => _WordLookupOverlayState();
}

class _WordLookupOverlayState extends State<WordLookupOverlay> {
  bool _expanded = false;

  bool get _hasContextNote =>
      widget.result != null &&
      !widget.result!.isError &&
      widget.result!.contextNote != null &&
      widget.result!.contextNote!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final result = widget.result;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
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
                    widget.word,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.isLoading)
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
                        Text('…', style: theme.textTheme.bodySmall),
                      ],
                    )
                  else if (result != null) ...[
                    Text(
                      result.isError
                          ? (result.errorMessage ?? 'Error')
                          : result.translation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: result.isError ? theme.colorScheme.error : null,
                      ),
                    ),
                    if (!result.isError &&
                        result.transcription != null &&
                        result.transcription!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '[${result.transcription}]',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (_hasContextNote && !_expanded)
                      GestureDetector(
                        onTap: _toggleExpand,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'more',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_hasContextNote && _expanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            result.contextNote!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            if (widget.onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: widget.onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleExpand() {
    setState(() => _expanded = true);
    widget.onExpand?.call();
  }
}
