import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kokoro_tts_flutter/kokoro_tts_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight wrapper for the Kokoro voices JSON structure.
class TtsVoice {
  final String id;
  final String name;
  final String language;

  TtsVoice({required this.id, required this.name, required this.language});

  factory TtsVoice.fromJson(Map<String, dynamic> json) {
    return TtsVoice(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String? ?? 'en-US',
    );
  }

  factory TtsVoice.fromMap(Map<String, String> map) {
    return TtsVoice(
      id: map['id']!,
      name: map['name']!,
      language: map['language']!,
    );
  }
}

class TtsService {
  static const _modelUrl =
      'https://huggingface.co/NeuML/kokoro-base-onnx/resolve/main/model.onnx';
  static const _voicesUrl =
      'https://huggingface.co/NeuML/kokoro-base-onnx/resolve/main/voices.json';

  TtsService._() {
    // Initialize with default voices, will be replaced when assets or downloaded file loads
    _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
    _emitVoices();
    // Try to load voices from assets immediately (async, won't block)
    _loadVoicesFromAssets().catchError((e) {
      debugPrint('[TtsService] Failed to load voices from assets on init: $e');
    });
    // Check if model was previously downloaded and restore state
    _restoreModelState().catchError((e) {
      debugPrint('[TtsService] Failed to restore model state: $e');
    });
  }

  static final TtsService instance = TtsService._();

  final ValueNotifier<double> downloadProgress = ValueNotifier(0);
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);
  final ValueNotifier<String?> textTruncationMessage = ValueNotifier(null);
  final Dio _dio = Dio();
  final ValueNotifier<List<TtsVoice>> voiceListNotifier = ValueNotifier(
    const [],
  );
  final AudioPlayer _audioPlayer = AudioPlayer();

  Kokoro? _kokoro;
  Tokenizer? _tokenizer;
  bool _modelReady = false;
  bool get isModelReady => _modelReady;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Completer<void>? _downloadCompleter;
  final List<TtsVoice> _voices = [];
  Completer<void>? _speechCompleter;
  String? _currentAudioPath;

  Future<void> ensureModelReady() async {
    if (_modelReady && _kokoro != null) return;
    if (_downloadCompleter != null) return _downloadCompleter!.future;
    _downloadCompleter = Completer();

    try {
      final modelDir = await _modelDirectory();
      final modelFile = File('${modelDir.path}/model.onnx');
      final voicesFile = File('${modelDir.path}/voices.json');

      final tasks = <_DownloadTask>[];
      if (!await modelFile.exists()) {
        tasks.add(_DownloadTask(_modelUrl, modelFile));
      }
      if (!await voicesFile.exists()) {
        tasks.add(_DownloadTask(_voicesUrl, voicesFile));
      }

      // Only set downloading flags if we actually need to download something
      if (tasks.isNotEmpty) {
        _isDownloading = true;
        downloadProgress.value = 0;
        await _downloadAssets(tasks);
        // Save state after successful download
        await _saveModelDownloadedState();
      }

      // Load voices from downloaded file (may contain more voices than assets version)
      // This will overwrite any voices loaded from assets
      await _loadVoicesFromFile(voicesFile);
      
      // Ensure we have at least some voices loaded (fallback to assets if needed)
      if (_voices.isEmpty) {
        debugPrint('[TtsService] No voices from downloaded file, loading from assets');
        await _loadVoicesFromAssets();
      }
      
      // Final fallback to defaults
      if (_voices.isEmpty) {
        debugPrint('[TtsService] No voices loaded, using defaults');
        _voices.clear();
        _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
        _emitVoices();
      }
      
      debugPrint('[TtsService] Model ready with ${_voices.length} voices available');

      // Initialize Kokoro
      if (_kokoro == null) {
        await _initializeKokoro(modelFile.path, voicesFile.path);
      }

      _modelReady = true;
      if (tasks.isEmpty) {
        // If no download was needed, set progress to 1 immediately
        downloadProgress.value = 1;
      }
      _downloadCompleter?.complete();
    } catch (error) {
      _downloadCompleter?.completeError(error);
      rethrow;
    } finally {
      _isDownloading = false;
      _downloadCompleter = null;
    }
  }

  /// Check if model files are already downloaded without initializing download
  Future<bool> isModelDownloaded() async {
    try {
      final modelDir = await _modelDirectory();
      final modelFile = File('${modelDir.path}/model.onnx');
      final voicesFile = File('${modelDir.path}/voices.json');
      return await modelFile.exists() && await voicesFile.exists();
    } catch (e) {
      debugPrint('[TtsService] Error checking if model is downloaded: $e');
      return false;
    }
  }

  /// Restore model state from SharedPreferences on initialization
  Future<void> _restoreModelState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasDownloaded = prefs.getBool('tts_model_downloaded') ?? false;
      if (wasDownloaded) {
        // Check if files still exist
        final modelDir = await _modelDirectory();
        final modelFile = File('${modelDir.path}/model.onnx');
        final voicesFile = File('${modelDir.path}/voices.json');
        if (await modelFile.exists() && await voicesFile.exists()) {
          // Files exist, mark as ready (but don't initialize Kokoro yet)
          _modelReady = true;
          downloadProgress.value = 1;
          debugPrint('[TtsService] Restored model state: model was previously downloaded');
        } else {
          // Files don't exist, clear the flag
          await prefs.remove('tts_model_downloaded');
          debugPrint('[TtsService] Model files missing, cleared download state');
        }
      }
    } catch (e) {
      debugPrint('[TtsService] Error restoring model state: $e');
    }
  }

  /// Save model downloaded state to SharedPreferences
  Future<void> _saveModelDownloadedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tts_model_downloaded', true);
      debugPrint('[TtsService] Saved model downloaded state');
    } catch (e) {
      debugPrint('[TtsService] Error saving model state: $e');
    }
  }

  Future<void> _initializeKokoro(String modelPath, String voicesPath) async {
    try {
      final config = KokoroConfig(modelPath: modelPath, voicesPath: voicesPath);
      _kokoro = Kokoro(config);
      await _kokoro!.initialize();

      // Initialize tokenizer for phonemization
      _tokenizer = Tokenizer();
      await _tokenizer!.ensureInitialized();
    } catch (e) {
      throw Exception('Failed to initialize Kokoro TTS: $e');
    }
  }

  Future<void> _downloadAssets(List<_DownloadTask> tasks) async {
    final step = 1 / tasks.length;
    int index = 0;
    for (final task in tasks) {
      if (!await task.destination.parent.exists()) {
        await task.destination.parent.create(recursive: true);
      }
      await _dio.download(
        task.url,
        task.destination.path,
        onReceiveProgress: (received, total) {
          final progressInPart = total > 0 ? received / total : 0.0;
          downloadProgress.value = ((index * step) + progressInPart * step)
              .clamp(0.0, 1.0);
        },
        options: Options(receiveTimeout: const Duration(minutes: 30)),
      );
      index++;
      downloadProgress.value = ((index) * step).clamp(0.0, 1.0);
    }
  }

  Future<Directory> _modelDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${appDir.path}/tts_models/kokoro');
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return modelDir;
  }

  Future<void> _loadVoicesFromFile(File voicesFile) async {
    if (!await voicesFile.exists()) {
      debugPrint('[TtsService] Voices file does not exist: ${voicesFile.path}');
      return;
    }
    try {
      final raw = await voicesFile.readAsString();
      final decoded = json.decode(raw) as Map<String, dynamic>;
      
      // Check if it's the metadata format (with "voices" array)
      if (decoded.containsKey('voices') && decoded['voices'] is List) {
        final voicesJson =
            (decoded['voices'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        _voices
          ..clear()
          ..addAll(voicesJson.map(TtsVoice.fromJson));
        debugPrint('[TtsService] Loaded ${_voices.length} voices from metadata format');
      } else {
        // It's the vectors format (keys are voice IDs)
        // Extract voice IDs and create TtsVoice objects from them
        final voiceIds = decoded.keys.toList();
        _voices.clear();
        for (final voiceId in voiceIds) {
          // Determine language from voice ID prefix
          final language = voiceId.startsWith('bf_') || voiceId.startsWith('bm_')
              ? 'en-GB'
              : 'en-US';
          
          // Create friendly name from ID
          String name;
          switch (voiceId) {
            case 'af':
              name = 'Amber (English US)';
              break;
            case 'af_bella':
              name = 'Bella (English US)';
              break;
            case 'af_nicole':
              name = 'Nicole (English US)';
              break;
            case 'af_sarah':
              name = 'Sarah (English US)';
              break;
            case 'af_sky':
              name = 'Sky (English US)';
              break;
            case 'am_adam':
              name = 'Adam (English US)';
              break;
            case 'am_michael':
              name = 'Michael (English US)';
              break;
            case 'bf_emma':
              name = 'Emma (English GB)';
              break;
            case 'bf_isabella':
              name = 'Isabella (English GB)';
              break;
            case 'bm_george':
              name = 'George (English GB)';
              break;
            case 'bm_lewis':
              name = 'Lewis (English GB)';
              break;
            default:
              // Fallback: format ID as name
              name = voiceId.replaceAll('_', ' ').split(' ')
                  .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
                  .join(' ') + ' (${language})';
          }
          
          _voices.add(TtsVoice(
            id: voiceId,
            name: name,
            language: language,
          ));
        }
        debugPrint('[TtsService] Loaded ${_voices.length} voices from vectors format');
      }
      _emitVoices();
    } catch (e) {
      debugPrint('[TtsService] Error loading voices from file: $e');
      // Keep existing voices or use defaults
      if (_voices.isEmpty) {
        _voices.clear();
        _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
        _emitVoices();
      }
    }
  }

  /// Load voices from assets as fallback (before model is downloaded)
  Future<void> _loadVoicesFromAssets() async {
    try {
      final raw = await rootBundle.loadString('assets/tts_models/kokoro/voices.json');
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final voicesJson =
          (decoded['voices'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      _voices
        ..clear()
        ..addAll(voicesJson.map(TtsVoice.fromJson));
      debugPrint('[TtsService] Loaded ${_voices.length} voices from assets');
      _emitVoices();
    } catch (e) {
      debugPrint('[TtsService] Error loading voices from assets: $e');
      // If assets loading fails, use defaults
      if (_voices.isEmpty) {
        _voices.clear();
        _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
        _emitVoices();
      }
    }
  }

  Future<void> ensureVoicesLoaded() async {
    final modelDir = await _modelDirectory();
    final voicesFile = File('${modelDir.path}/voices.json');
    
    debugPrint('[TtsService] ensureVoicesLoaded: checking ${voicesFile.path}');
    debugPrint('[TtsService] File exists: ${await voicesFile.exists()}');
    debugPrint('[TtsService] Current voices count: ${_voices.length}');
    
    // Priority 1: Try to load voices from downloaded model file (most complete)
    if (await voicesFile.exists()) {
      await _loadVoicesFromFile(voicesFile);
    } else {
      debugPrint('[TtsService] Downloaded voices file not found, trying assets');
      // Priority 2: Try to load from assets (fallback, available immediately)
      await _loadVoicesFromAssets();
    }
    
    // Priority 3: If no voices loaded, ensure default voices are available
    if (_voices.isEmpty) {
      debugPrint('[TtsService] No voices loaded, using default voices');
      _voices.clear();
      _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
      _emitVoices();
    }
    
    debugPrint('[TtsService] Final voices count: ${_voices.length}');
  }

  List<TtsVoice> get availableVoices => voiceListNotifier.value;

  void _emitVoices() {
    voiceListNotifier.value = List.unmodifiable(_voices);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete();
    }
    _speechCompleter = null;
    isSpeaking.value = false;

    // Clean up temporary audio file
    if (_currentAudioPath != null) {
      try {
        final file = File(_currentAudioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
      _currentAudioPath = null;
    }
  }

  Future<void> speak({
    required String text,
    required String voiceId,
    required double speed,
  }) async {
    if (text.trim().isEmpty) return;
    final completer = Completer<void>();
    try {
      await ensureModelReady();

      if (_kokoro == null) {
        throw Exception('Kokoro TTS not initialized');
      }

      final voice = _voices.firstWhere(
        (voice) => voice.id == voiceId,
        orElse:
            () =>
                _voices.isNotEmpty
                    ? _voices.first
                    : TtsVoice(
                      id: 'af',
                      name: 'Amber (English US)',
                      language: 'en-US',
                    ),
      );

      // Convert language code from 'en-US' to 'en-us' format
      final langCode = voice.language.toLowerCase().replaceAll('_', '-');

      // Phonemize text using Tokenizer
      if (_tokenizer == null) {
        _tokenizer = Tokenizer();
        await _tokenizer!.ensureInitialized();
      }
      
      String phonemes;
      try {
        phonemes = await _tokenizer!.phonemize(text, lang: langCode);
      } catch (e) {
        // If phonemization fails due to missing assets, throw a more descriptive error
        // Don't try to use text directly as Kokoro may not handle it well
        if (e.toString().contains('us_gold.json') || 
            e.toString().contains('Unable to load asset') ||
            e.toString().contains('lexicon')) {
          debugPrint('Error: Phonemization failed due to missing assets: $e');
          throw Exception(
            'Phonemization failed: Required asset files are missing. '
            'Please ensure all TTS assets are properly installed. '
            'Original error: $e',
          );
        } else {
          rethrow;
        }
      }

      // Check phoneme length and truncate if needed (Kokoro limit is 510 phonemes)
      // The library counts phonemes - need to be very conservative
      // Based on testing, even 667 chars causes error, so use 400 chars max
      const maxPhonemeChars = 400; // Very conservative: well below 510 phoneme limit
      const safePhonemeChars = 300; // Even more conservative for retry
      const minPhonemeChars = 200; // Absolute minimum
      
      String truncatedPhonemes = phonemes;
      bool wasTruncated = false;
      final originalLength = phonemes.length;
      
      if (phonemes.length > maxPhonemeChars) {
        debugPrint('[TtsService] Phonemes too long: $originalLength chars, truncating to $maxPhonemeChars');
        // Truncate by character length, trying to break at word boundaries (spaces)
        truncatedPhonemes = phonemes.substring(0, maxPhonemeChars);
        // Try to find last space to break at word boundary
        final lastSpace = truncatedPhonemes.lastIndexOf(' ');
        if (lastSpace > maxPhonemeChars * 0.7) {
          truncatedPhonemes = truncatedPhonemes.substring(0, lastSpace);
        }
        wasTruncated = true;
        debugPrint('[TtsService] Truncated to ${truncatedPhonemes.length} chars');
      }

      // Synthesize speech using Kokoro
      TtsResult result;
      try {
        result = await _kokoro!.createTTS(
          text: truncatedPhonemes,
          voice: voice.id,
          isPhonemes: true,
          speed: speed.clamp(0.5, 1.5),
        );
      } catch (e) {
        // If still fails with "too long" error, try more aggressive truncation
        if (e.toString().contains('510 phonemes') || 
            e.toString().contains('too long') ||
            e.toString().contains('must be less than')) {
          debugPrint('[TtsService] Still too long after truncation, using more aggressive truncation');
          // Use the already truncated phonemes and truncate further
          final currentLength = truncatedPhonemes.length;
          int targetLength;
          
          if (currentLength > safePhonemeChars) {
            targetLength = safePhonemeChars;
          } else if (currentLength > minPhonemeChars) {
            targetLength = minPhonemeChars;
          } else {
            // Already at minimum, reduce by 50%
            targetLength = (currentLength * 0.5).round();
          }
          
          if (targetLength < currentLength && targetLength > 100) {
            truncatedPhonemes = truncatedPhonemes.substring(0, targetLength);
            // Try to find last space to break at word boundary
            final lastSpace = truncatedPhonemes.lastIndexOf(' ');
            if (lastSpace > targetLength * 0.5) {
              truncatedPhonemes = truncatedPhonemes.substring(0, lastSpace);
            }
            wasTruncated = true;
            debugPrint('[TtsService] Retry with ${truncatedPhonemes.length} chars (was $currentLength)');
            result = await _kokoro!.createTTS(
              text: truncatedPhonemes,
              voice: voice.id,
              isPhonemes: true,
              speed: speed.clamp(0.5, 1.5),
            );
          } else {
            // Can't truncate further, throw error with message
            debugPrint('[TtsService] Cannot truncate further, text is already at minimum length');
            throw Exception(
              'Text is too long for voice synthesis. Please use shorter text or split it into parts.',
            );
          }
        } else {
          rethrow;
        }
      }
      
      // If text was truncated, notify UI
      if (wasTruncated) {
        debugPrint('[TtsService] Text was truncated from $originalLength to ${truncatedPhonemes.length} chars');
      }

      // Save audio to temporary file
      final tempDir = await getTemporaryDirectory();
      final audioFile = File(
        '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      _currentAudioPath = audioFile.path;

      // Convert audio data to Float32List and save to WAV file
      final audioData =
          result.audio is Float32List
              ? result.audio as Float32List
              : Float32List.fromList(
                result.audio.map((e) => e.toDouble()).toList(),
              );
      await _saveAudioToFile(audioData, result.sampleRate, audioFile);

      // Play audio using AudioPlayer
      _speechCompleter = completer;
      isSpeaking.value = true;

      StreamSubscription? completeSubscription;
      completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        completeSubscription?.cancel();
      });

      // If text was truncated, notify UI (audio will still play)
      if (wasTruncated) {
        textTruncationMessage.value = 
          'Text is too long. Only the first part is being played.';
      } else {
        textTruncationMessage.value = null;
      }

      try {
        await _audioPlayer.play(DeviceFileSource(audioFile.path));
        await completer.future;
      } finally {
        completeSubscription.cancel();
        // Clear truncation message after playback
        textTruncationMessage.value = null;
      }
    } catch (error) {
      // Clear truncation message on error
      textTruncationMessage.value = null;
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
      rethrow;
    } finally {
      if (_speechCompleter == completer) {
        _speechCompleter = null;
      }
      isSpeaking.value = false;

      // Clean up temporary audio file
      if (_currentAudioPath != null) {
        try {
          final file = File(_currentAudioPath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Ignore cleanup errors
        }
        _currentAudioPath = null;
      }
    }
  }

  Future<void> _saveAudioToFile(
    Float32List audioData,
    int sampleRate,
    File outputFile,
  ) async {
    // Convert Float32List to Int16List (PCM16)
    final pcmData = Int16List(audioData.length);
    for (int i = 0; i < audioData.length; i++) {
      final sample = (audioData[i] * 32767.0).clamp(-32768.0, 32767.0);
      pcmData[i] = sample.round();
    }

    // Write WAV file header and data
    final file = await outputFile.open(mode: FileMode.write);
    try {
      // WAV header
      await file.writeFrom(_createWavHeader(pcmData.length, sampleRate));
      // PCM data
      await file.writeFrom(pcmData.buffer.asUint8List());
    } finally {
      await file.close();
    }
  }

  Uint8List _createWavHeader(int dataLength, int sampleRate) {
    final header = ByteData(44);
    final dataSize = dataLength * 2; // 16-bit = 2 bytes per sample

    // RIFF header
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    header.setUint32(4, 36 + dataSize, Endian.little); // File size - 8

    // WAVE header
    header.setUint8(8, 0x57); // 'W'
    header.setUint8(9, 0x41); // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'

    // fmt chunk
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    header.setUint32(16, 16, Endian.little); // fmt chunk size
    header.setUint16(20, 1, Endian.little); // Audio format (PCM)
    header.setUint16(22, 1, Endian.little); // Number of channels (mono)
    header.setUint32(24, sampleRate, Endian.little); // Sample rate
    header.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
    header.setUint16(32, 2, Endian.little); // Block align
    header.setUint16(34, 16, Endian.little); // Bits per sample

    // data chunk
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    header.setUint32(40, dataSize, Endian.little); // Data size

    return header.buffer.asUint8List();
  }
}

class _DownloadTask {
  final String url;
  final File destination;

  _DownloadTask(this.url, this.destination);
}


const _kDefaultVoices = <Map<String, String>>[
  {'id': 'af', 'name': 'Amber (English US)', 'language': 'en-US'},
  {'id': 'bf', 'name': 'Basil (English UK)', 'language': 'en-GB'},
  {'id': 'cf', 'name': 'Celeste (English US)', 'language': 'en-US'},
];
