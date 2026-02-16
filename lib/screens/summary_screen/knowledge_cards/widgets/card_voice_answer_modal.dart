import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/summaryApi.dart';

/// Full-screen modal for answering a knowledge card by voice.
/// User taps mic to record, sees transcribed text, and can send (stub: no server yet).
class CardVoiceAnswerModal extends StatefulWidget {
  final KnowledgeCard card;

  const CardVoiceAnswerModal({
    super.key,
    required this.card,
  });

  @override
  State<CardVoiceAnswerModal> createState() => _CardVoiceAnswerModalState();
}

class _CardVoiceAnswerModalState extends State<CardVoiceAnswerModal>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  String _recognizedText = '';
  String _errorMessage = '';
  bool _isSending = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _initSpeech();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (_isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (e) => setState(() => _errorMessage = e.errorMsg),
        onStatus: (_) {},
      );
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      await _initSpeech();
      if (!_speechAvailable) return;
    }
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }
    setState(() {
      _errorMessage = '';
      _isListening = true;
    });
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() => _recognizedText = result.recognizedWords);
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
      ),
    );
    if (mounted) setState(() => _isListening = true);
  }

  Future<void> _onSend() async {
    final l10n = AppLocalizations.of(context);
    if (_isSending) return;
    setState(() => _isSending = true);
    try {
      final result = await SummaryRepository().verifyKnowledgeCardAnswer(
        cardTitle: widget.card.title,
        cardContent: widget.card.content,
        userAnswer: _recognizedText.trim().isEmpty ? ' ' : _recognizedText.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.shortFeedback} — ${result.accuracy}%'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } on KnowledgeCardVerifyUnavailableException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.knowledgeCards_voiceAnswerStubMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _errorMessage = l10n.knowledgeCards_voiceAnswerError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.knowledgeCards_voiceAnswerTitle(widget.card.title),
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Mic button and listening indicator
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _speechAvailable ? _toggleListening : null,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale =
                              1.0 + (_isListening ? 0.1 * _pulseController.value : 0.0);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isListening
                                    ? Colors.red.shade100
                                    : Colors.grey.shade200,
                              ),
                              child: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                size: 40,
                                color: _isListening ? Colors.red : Colors.grey.shade700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isListening
                          ? l10n.knowledgeCards_listening
                          : l10n.knowledgeCards_tapMicToSpeak,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Recognized text
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _recognizedText.isEmpty
                          ? ' '
                          : _recognizedText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Send button
              FilledButton(
                onPressed: _isSending ? null : _onSend,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.knowledgeCards_voiceAnswerSend),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
