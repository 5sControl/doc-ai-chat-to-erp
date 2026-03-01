import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../services/tts_service.dart';
import 'markdown_tts_highlight_builder.dart';
import 'markdown_word_tap_builder.dart'
    show MarkdownWordTapBuilder, wordBoundariesAtOffset;

/// Callback to show word lookup outside the control (e.g. via system overlay).
/// Called when user double-taps a word while showing original (untranslated) text.
typedef OnWordLookup = void Function(BuildContext context, String word);

/// Shown at most once per app session so multiple tabs don't show the hint repeatedly.
bool _wordTapHintShownThisSession = false;

class SummaryTextContainer extends StatefulWidget {
  final String summaryText;
  final Summary summary;
  final SummaryStatus summaryStatus;
  final SummaryTranslate? summaryTranslate;

  /// Tab index (0=source, 1=brief, 2=deep) for TTS highlight matching.
  final int tabIndex;

  /// Summary key for TTS highlight matching.
  final String summaryKey;

  /// If set, double-tap on a word (when showing original text) will call this
  /// with (context, word). The host can show translation via overlay/snack/etc.
  final OnWordLookup? onWordLookup;

  const SummaryTextContainer({
    super.key,
    required this.summaryText,
    required this.summary,
    required this.summaryStatus,
    required this.summaryTranslate,
    required this.tabIndex,
    required this.summaryKey,
    this.onWordLookup,
  });

  @override
  State<SummaryTextContainer> createState() => _SummaryTextContainerState();
}

class _SummaryTextContainerState extends State<SummaryTextContainer> {
  late final ScrollController _scrollController;
  Timer? _wordTapHintTimer;

  bool _isShowingOriginalText(SummaryTranslate? summaryTranslate) =>
      summaryTranslate == null || !summaryTranslate.isActive;

  bool _shouldShowTtsHighlight(TtsService tts) {
    if (!tts.isSpeaking.value) return false;
    final ctx = tts.playbackContext.value;
    if (ctx == null) return false;
    return ctx.summaryKey == widget.summaryKey &&
        ctx.activeTab == widget.tabIndex;
  }

  Map<String, MarkdownElementBuilder> _ttsHighlightBuilders(
    BuildContext context,
    OnWordLookup? onWordLookup,
    List<int> blockOffsets,
    int readEndIndex,
    int currentWordStart,
    int currentWordEnd,
  ) {
    final onWordTap = onWordLookup != null
        ? (w) => _onWordTap(context, w, onWordLookup)
        : (_) {};
    final builder = MarkdownTtsHighlightBuilder(
      onWordTap: onWordTap,
      blockOffsets: blockOffsets,
      readEndIndex: readEndIndex,
      currentWordStart: currentWordStart,
      currentWordEnd: currentWordEnd,
    );
    return {
      'p': builder,
      'h1': builder,
      'h2': builder,
      'h3': builder,
      'h4': builder,
      'h5': builder,
      'h6': builder,
      'li': builder,
      'blockquote': builder,
    };
  }

  Map<String, MarkdownElementBuilder> _wordTapBuilders(
    BuildContext context,
    OnWordLookup onWordLookup,
  ) {
    return {
      'p': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h1': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h2': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h3': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h4': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h5': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'h6': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'li': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
      'blockquote': MarkdownWordTapBuilder(
          onWordTap: (w) => _onWordTap(context, w, onWordLookup)),
    };
  }

  void _onWordTap(BuildContext context, String word, OnWordLookup callback) {
    if (_isShowingOriginalText(widget.summaryTranslate)) {
      final trimmed = word.trim();
      if (trimmed.isNotEmpty) callback(context, trimmed);
    }
  }

  void _maybeShowWordTapHint() {
    if (!mounted) return;
    if (_wordTapHintShownThisSession) return;
    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState.wordTapHintDismissed) return;
    _wordTapHintShownThisSession = true;
    final l10n = AppLocalizations.of(context);
    final scaffoldContext = context;
    showDialog<void>(
      context: scaffoldContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.wordTapHint_title),
        content: Text(l10n.wordTapHint_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.wordTapHint_showLater),
          ),
          TextButton(
            onPressed: () {
              scaffoldContext.read<SettingsBloc>().add(const WordTapHintDismissed());
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.wordTapHint_dontShowAgain),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.onWordLookup != null && _isShowingOriginalText(widget.summaryTranslate)) {
      _wordTapHintTimer = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        _maybeShowWordTapHint();
      });
    }
  }

  @override
  void dispose() {
    _wordTapHintTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Top inset: match tab bar height so text starts right below it (no gap).
  static const double _kViewportTopInset = 57;

  /// Height of fade gradient at top and bottom edges.
  static const double _kFadeHeight = 24;

  static Color _contentBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromRGBO(15, 57, 60, 1)
        : const Color.fromRGBO(191, 249, 249, 1);
  }

  @override
  Widget build(BuildContext context) {
    final onWordLookup = widget.onWordLookup;
    final bottomInset = -5 + MediaQuery.of(context).padding.bottom;
    final backgroundColor = _contentBackgroundColor(context);

    return Padding(
      padding: EdgeInsets.only(
        top: _kViewportTopInset,
        left: 15,
        right: 15,
        bottom: bottomInset,
      ),
      child: Stack(
        children: [
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(left: 0, right: 0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
          key: Key(widget.summaryTranslate != null && widget.summaryTranslate!.isActive
              ? 'short'
              : 'long'),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final ttsService = TtsService.instance;
              return ValueListenableBuilder<TtsPlaybackContext?>(
                valueListenable: ttsService.playbackContext,
                builder: (context, _, __) {
                  return ValueListenableBuilder<Duration?>(
                    valueListenable: ttsService.playbackPosition,
                    builder: (context, ___, ____) {
                      return Builder(
                        builder: (context) {
                          final textToDisplay =
                      widget.summaryTranslate != null && widget.summaryTranslate!.isActive
                          ? (widget.summaryTranslate!.translate ?? widget.summaryText)
                          : widget.summaryText;

                  final styleSheet = MarkdownStyleSheet(
                    h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() + 8,
                          fontWeight: FontWeight.bold,
                        ),
                    h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: state.fontSize.toDouble() + 6,
                          fontWeight: FontWeight.bold,
                        ),
                    h3: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: state.fontSize.toDouble() + 4,
                          fontWeight: FontWeight.bold,
                        ),
                    h4: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: state.fontSize.toDouble() + 2,
                          fontWeight: FontWeight.bold,
                        ),
                    h5: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() + 1,
                          fontWeight: FontWeight.bold,
                        ),
                    h6: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                    p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                        ),
                    strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                    em: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontStyle: FontStyle.italic,
                        ),
                    listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                        ),
                    listIndent: 24,
                    blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                    code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() - 1,
                          fontFamily: 'monospace',
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                    codeblockDecoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                  );

                  final showTtsHighlight = _isShowingOriginalText(widget.summaryTranslate) &&
                      _shouldShowTtsHighlight(ttsService);

                  int readEndIndex = 0;
                  int currentWordStart = 0;
                  int currentWordEnd = 0;

                  final (blockOffsets, flattenedText) = showTtsHighlight
                      ? computeBlockOffsets(textToDisplay)
                      : (<int>[], '');

                  if (showTtsHighlight && flattenedText.isNotEmpty) {
                    final pos = ttsService.playbackPosition.value;
                    final dur = ttsService.playbackDuration.value;
                    if (pos != null &&
                        dur != null &&
                        dur.inMilliseconds > 0) {
                      final progress =
                          pos.inMilliseconds / dur.inMilliseconds;
                      final estimatedCharIndex = (progress * flattenedText.length)
                          .round()
                          .clamp(0, flattenedText.length);
                      final (ws, we) =
                          wordBoundariesAtOffset(flattenedText, estimatedCharIndex);
                      readEndIndex = ws;
                      currentWordStart = ws;
                      currentWordEnd = we;
                    }
                  }

                  final builders =
                      _isShowingOriginalText(widget.summaryTranslate)
                          ? <String, MarkdownElementBuilder>{
                              if (showTtsHighlight)
                                ..._ttsHighlightBuilders(
                                  context,
                                  onWordLookup,
                                  blockOffsets,
                                  readEndIndex,
                                  currentWordStart,
                                  currentWordEnd,
                                )
                              else if (onWordLookup != null)
                                ..._wordTapBuilders(context, onWordLookup),
                            }
                          : const <String, MarkdownElementBuilder>{};

                          return Animate(
                            effects: const [FadeEffect()],
                            child: MarkdownBody(
                              data: textToDisplay,
                              selectable: true,
                              styleSheet: styleSheet,
                              builders: builders,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
              ),
            ),
          ),
        ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _kFadeHeight,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _kFadeHeight,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
