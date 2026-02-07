import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import 'markdown_word_tap_builder.dart';

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

  /// If set, double-tap on a word (when showing original text) will call this
  /// with (context, word). The host can show translation via overlay/snack/etc.
  final OnWordLookup? onWordLookup;

  const SummaryTextContainer({
    super.key,
    required this.summaryText,
    required this.summary,
    required this.summaryStatus,
    required this.summaryTranslate,
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

  @override
  Widget build(BuildContext context) {
    final onWordLookup = widget.onWordLookup;

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 60, bottom: 90, left: 15, right: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          key: Key(widget.summaryTranslate != null && widget.summaryTranslate!.isActive
              ? 'short'
              : 'long'),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
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

                  final builders =
                      _isShowingOriginalText(widget.summaryTranslate) && onWordLookup != null
                          ? <String, MarkdownElementBuilder>{
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
          ),
        ),
      ),
    );
  }
}
