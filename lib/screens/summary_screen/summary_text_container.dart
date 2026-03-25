import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../helpers/get_transformed_text.dart';
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
  DateTime? _lastHighlightLog;
  bool _blockOrderLogged = false;
  /// Deferred by one frame to avoid OOM when TTS starts (phonemization + cache leave heap full; highlight build does many substrings).
  bool _ttsHighlightReady = false;
  static const bool _kLogHighlight = true;

  /// TODO: TTS highlight disabled to restore sound/playback. computeBlockOffsets + _buildTtsHighlightPlain cause OOM (Exhausted heap space). Re-enable when we have a memory-safe implementation (e.g. chunked/lazy highlight or skip highlight for long text).
  static const bool _kTtsHighlightEnabled = false;

  void _logHighlightIfNeeded({
    required bool showTtsHighlight,
    required bool hasCtx,
    required Duration? pos,
    required Duration? dur,
    required int fullLen,
    required int flatLen,
    required int readEndIndex,
    required int currentWordStart,
    required int currentWordEnd,
  }) {
    if (!_kLogHighlight || !showTtsHighlight) return;
    final now = DateTime.now();
    if (_lastHighlightLog != null &&
        now.difference(_lastHighlightLog!).inMilliseconds < 800) {
      return;
    }
    _lastHighlightLog = now;
    debugPrint(
      '[SummaryTextContainer] HIGHLIGHT_DEBUG: tab=${widget.tabIndex} hasCtx=$hasCtx '
      'pos=${pos?.inMilliseconds}ms dur=${dur?.inMilliseconds}ms '
      'fullLen=$fullLen flatLen=$flatLen readEnd=$readEndIndex word=$currentWordStart-$currentWordEnd',
    );
  }

  bool _isShowingOriginalText(SummaryTranslate? summaryTranslate) =>
      summaryTranslate == null || !summaryTranslate.isActive;

  /// TTS highlight is shown only on the tab that is currently playing.
  /// tabIndex 0 = source, 1 = brief, 2 = deep. Stay on the same tab where you pressed Play.
  bool _shouldShowTtsHighlight(TtsService tts) {
    if (!tts.isSpeaking.value) return false;
    final ctx = tts.playbackContext.value;
    if (ctx == null) return false;
    return ctx.summaryKey == widget.summaryKey &&
        ctx.activeTab == widget.tabIndex;
  }

  /// Plain-text TTS highlight when MarkdownBody builders are not invoked.
  /// Shows flattened text with read/current word highlighting so user sees progress.
  Widget _buildTtsHighlightPlain(
    BuildContext context,
    String flattenedText,
    int readEndIndex,
    int currentWordStart,
    int currentWordEnd,
    MarkdownStyleSheet styleSheet,
    double fontSize,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final readColor = (isDark ? Colors.amber : Colors.amber.shade200)
        .withValues(alpha: isDark ? 0.35 : 0.5);
    final currentColor = (isDark ? Colors.amber : Colors.amber.shade700)
        .withValues(alpha: isDark ? 0.5 : 0.65);

    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: fontSize,
        ) ??
        TextStyle(fontSize: fontSize);

    final spans = <TextSpan>[];
    int i = 0;
    while (i < flattenedText.length) {
      final (wordStart, wordEnd) = wordBoundariesAtOffset(flattenedText, i);
      if (wordStart >= wordEnd) {
        spans.add(TextSpan(text: flattenedText[i], style: baseStyle));
        i++;
        continue;
      }
      final word = flattenedText.substring(wordStart, wordEnd);
      Color? backgroundColor;
      TextStyle spanStyle = baseStyle;
      if (wordStart < currentWordEnd && wordEnd > currentWordStart) {
        backgroundColor = currentColor;
        spanStyle = spanStyle.copyWith(
          backgroundColor: currentColor,
          decoration: TextDecoration.underline,
          decorationColor: Colors.orange,
          decorationThickness: 2,
        );
      } else if (wordEnd <= readEndIndex) {
        backgroundColor = readColor;
        spanStyle = spanStyle.copyWith(backgroundColor: readColor);
      }
      spans.add(TextSpan(text: word, style: spanStyle));
      i = wordEnd;
    }

    return SelectableText.rich(
      TextSpan(children: spans, style: baseStyle),
      textAlign: TextAlign.start,
    );
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
                  /// ~one body line of vertical space; Markdown ignores leading/trailing blank lines here.
                  final verticalPad = state.fontSize * 1.35;
                  final markdownData =
                      splitHorizontalRuleFromHeading(textToDisplay);

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
                  // Defer heavy highlight (computeBlockOffsets + many substrings) by one frame to avoid OOM when TTS just started.
                  // When _kTtsHighlightEnabled is false, highlight is fully off (TODO: re-enable after memory-safe implementation).
                  final effectiveShowTtsHighlight = _kTtsHighlightEnabled && showTtsHighlight && _ttsHighlightReady;
                  if (_kTtsHighlightEnabled && showTtsHighlight && !_ttsHighlightReady) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _ttsHighlightReady = true);
                    });
                  } else if (_kTtsHighlightEnabled && !showTtsHighlight && _ttsHighlightReady) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _ttsHighlightReady = false);
                    });
                  }

                  int readEndIndex = 0;
                  int currentWordStart = 0;
                  int currentWordEnd = 0;

                  final (blockOffsets, flattenedText) = effectiveShowTtsHighlight
                      ? computeBlockOffsets(markdownData)
                      : (<int>[], '');

                  if (effectiveShowTtsHighlight &&
                      blockOffsets.isNotEmpty &&
                      flattenedText.isNotEmpty &&
                      !_blockOrderLogged) {
                    _blockOrderLogged = true;
                    for (var i = 0; i < blockOffsets.length && i < 15; i++) {
                      final start = blockOffsets[i];
                      final len = i + 1 < blockOffsets.length
                          ? blockOffsets[i + 1] - start - 1
                          : flattenedText.length - start;
                      debugPrint(
                        '[SummaryTextContainer] BLOCK_COMPUTED: idx=$i start=$start len=$len',
                      );
                    }
                  }
                  if (!effectiveShowTtsHighlight) _blockOrderLogged = false;

                  if (effectiveShowTtsHighlight && flattenedText.isNotEmpty) {
                    final ctx = ttsService.playbackContext.value;
                    final pos = ttsService.playbackPosition.value;
                    final dur = ttsService.playbackDuration.value;
                    if (ctx != null &&
                        ctx.fullText != null &&
                        ctx.fullText!.isNotEmpty &&
                        flattenedText.isNotEmpty) {
                      final fullLen = ctx.fullText!.length;
                      int playedChars = ctx.playedUpToCharIndex;
                      if (ctx.text != null &&
                          ctx.text!.isNotEmpty &&
                          pos != null &&
                          dur != null &&
                          dur.inMilliseconds > 0) {
                        final progress =
                            pos.inMilliseconds / dur.inMilliseconds;
                        playedChars = (ctx.playedUpToCharIndex +
                                (progress * ctx.text!.length).round())
                            .clamp(0, fullLen);
                        final estimatedCharIndex = (playedChars / fullLen * flattenedText.length)
                            .round()
                            .clamp(0, flattenedText.length);
                        final (ws, we) =
                            wordBoundariesAtOffset(flattenedText, estimatedCharIndex);
                        currentWordStart = ws;
                        currentWordEnd = we;
                      }
                      readEndIndex = fullLen > 0
                          ? (playedChars / fullLen * flattenedText.length)
                              .round()
                              .clamp(0, flattenedText.length)
                          : 0;
                    } else if (pos != null &&
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
                    _logHighlightIfNeeded(
                      showTtsHighlight: effectiveShowTtsHighlight,
                      hasCtx: ctx != null,
                      pos: pos,
                      dur: dur,
                      fullLen: ctx?.fullText?.length ?? 0,
                      flatLen: flattenedText.length,
                      readEndIndex: readEndIndex,
                      currentWordStart: currentWordStart,
                      currentWordEnd: currentWordEnd,
                    );
                  }

                  final builders =
                      _isShowingOriginalText(widget.summaryTranslate)
                          ? <String, MarkdownElementBuilder>{
                              if (effectiveShowTtsHighlight)
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
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: verticalPad,
                        bottom: verticalPad,
                      ),
                      child: effectiveShowTtsHighlight && flattenedText.isNotEmpty
                          ? _buildTtsHighlightPlain(
                              context,
                              flattenedText,
                              readEndIndex,
                              currentWordStart,
                              currentWordEnd,
                              styleSheet,
                              state.fontSize.toDouble(),
                            )
                          : MarkdownBody(
                              data: markdownData,
                              selectable: true,
                              styleSheet: styleSheet,
                              builders: builders,
                            ),
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
