import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../services/tts_service.dart';
import 'summary_text_container.dart';
import 'word_lookup_overlay.dart';

/// Creates a unified word lookup handler that shows the translation overlay and
/// optionally auto-plays TTS for 1-3 words.
OnWordLookup createWordLookupHandler(
  BuildContext context, {
  bool enableAutoSpeak = true,
}) {
  return (BuildContext ctx, String word) {
    final targetLang = ctx.read<SettingsBloc>().state.translateLanguage;
    showWordLookupOverlay(
      ctx,
      word: word,
      targetLang: targetLang,
      duration: word.length > 40
          ? const Duration(seconds: 5)
          : WordLookupOverlay.defaultDuration,
      onSpeakWord: enableAutoSpeak
          ? (w) async {
              if (await TtsService.instance.isModelDownloaded()) {
                if (!ctx.mounted) return;
                final settings = ctx.read<SettingsBloc>().state;
                TtsService.instance.speak(
                  text: w,
                  voiceId: settings.kokoroVoiceId,
                  speed: settings.kokoroSynthesisSpeed,
                );
              }
            }
          : null,
    );
  };
}
