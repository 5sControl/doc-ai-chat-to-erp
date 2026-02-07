import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../models/models.dart';
import '../../services/tts_service.dart';
import '../../services/word_translate_service.dart';
import 'markdown_word_tap_builder.dart';
import 'word_lookup_overlay.dart';

class SummaryTextContainer extends StatefulWidget {
  final String summaryText;
  final Summary summary;
  final SummaryStatus summaryStatus;
  final SummaryTranslate? summaryTranslate;

  const SummaryTextContainer({
    super.key,
    required this.summaryText,
    required this.summary,
    required this.summaryStatus,
    required this.summaryTranslate,
  });

  @override
  State<SummaryTextContainer> createState() => _SummaryTextContainerState();
}

class _SummaryTextContainerState extends State<SummaryTextContainer> {
  String? _visibleWord;
  WordLookupResult? _lookupResult;
  bool _lookupLoading = false;
  Timer? _hideOverlayTimer;

  bool get _isShowingOriginalText =>
      widget.summaryTranslate == null || !widget.summaryTranslate!.isActive;

  void _onWordTap(String word) {
    if (!_isShowingOriginalText) return;
    final trimmed = word.trim();
    if (trimmed.isEmpty) return;

    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = null;

    setState(() {
      _visibleWord = trimmed;
      _lookupResult = null;
      _lookupLoading = true;
    });

    final targetLang = context.read<SettingsBloc>().state.translateLanguage;
    WordTranslateService.instance.lookup(trimmed, targetLang).then((result) {
      if (!mounted) return;
      setState(() {
        _lookupResult = result;
        _lookupLoading = false;
      });
      _hideOverlayTimer = Timer(WordLookupOverlay.defaultDuration, () {
        if (mounted) {
          setState(() {
            _visibleWord = null;
            _lookupResult = null;
            _hideOverlayTimer = null;
          });
        }
      });

      if (!result.isError) {
        TtsService.instance.isModelDownloaded().then((downloaded) {
          if (downloaded && mounted) {
            final settings = context.read<SettingsBloc>().state;
            TtsService.instance.speak(
              text: trimmed,
              voiceId: settings.kokoroVoiceId,
              speed: settings.kokoroSynthesisSpeed,
            );
          }
        });
      }
    });
  }

  void _dismissOverlay() {
    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = null;
    setState(() {
      _visibleWord = null;
      _lookupResult = null;
      _lookupLoading = false;
    });
  }

  @override
  void dispose() {
    _hideOverlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            controller: scrollController,
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

                      final builders = _isShowingOriginalText
                          ? <String, MarkdownElementBuilder>{
                              'p': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h1': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h2': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h3': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h4': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h5': MarkdownWordTapBuilder(onWordTap: _onWordTap),
                              'h6': MarkdownWordTapBuilder(onWordTap: _onWordTap),
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
          if (_visibleWord != null)
            Positioned(
              top: 68,
              left: 0,
              right: 0,
              child: SafeArea(
                child: WordLookupOverlay(
                  word: _visibleWord!,
                  result: _lookupResult,
                  isLoading: _lookupLoading,
                  onDismiss: _dismissOverlay,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
