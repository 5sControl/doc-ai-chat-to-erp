import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

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
    _flutterTts.setSharedInstance(true);
    _voices.addAll(_kDefaultVoices.map(TtsVoice.fromMap));
    _emitVoices();
  }

  static final TtsService instance = TtsService._();

  final FlutterTts _flutterTts = FlutterTts();
  final ValueNotifier<double> downloadProgress = ValueNotifier(0);
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);
  final Dio _dio = Dio();
  final ValueNotifier<List<TtsVoice>> voiceListNotifier = ValueNotifier(
    const [],
  );

  bool _modelReady = false;
  bool get isModelReady => _modelReady;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Completer<void>? _downloadCompleter;
  final List<TtsVoice> _voices = [];
  Completer<void>? _speechCompleter;

  Future<void> ensureModelReady() async {
    if (_modelReady) return;
    if (_downloadCompleter != null) return _downloadCompleter!.future;
    _downloadCompleter = Completer();
    _isDownloading = true;
    downloadProgress.value = 0;

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

      if (tasks.isNotEmpty) {
        await _downloadAssets(tasks);
      }

      await _loadVoicesFromFile(voicesFile);
      _modelReady = true;
      downloadProgress.value = 1;
      _downloadCompleter?.complete();
    } catch (error) {
      _downloadCompleter?.completeError(error);
      rethrow;
    } finally {
      _isDownloading = false;
      _downloadCompleter = null;
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
    if (!await voicesFile.exists()) return;
    final raw = await voicesFile.readAsString();
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final voicesJson =
        (decoded['voices'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>();
    _voices
      ..clear()
      ..addAll(voicesJson.map(TtsVoice.fromJson));
    _emitVoices();
  }

  Future<void> ensureVoicesLoaded() async {
    final modelDir = await _modelDirectory();
    final voicesFile = File('${modelDir.path}/voices.json');
    await _loadVoicesFromFile(voicesFile);
  }

  List<TtsVoice> get availableVoices => voiceListNotifier.value;

  void _emitVoices() {
    voiceListNotifier.value = List.unmodifiable(_voices);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete();
    }
    _speechCompleter = null;
    isSpeaking.value = false;
  }

  Future<void> speak({
    required String text,
    required String voiceId,
    required double speed,
  }) async {
    if (text.trim().isEmpty) return;
    try {
      await ensureModelReady();
      final voice = _voices.firstWhere(
        (voice) => voice.id == voiceId,
        orElse:
            () =>
                _voices.isNotEmpty
                    ? _voices.first
                    : TtsVoice(
                      id: 'default',
                      name: 'Default',
                      language: 'en-US',
                    ),
      );

      await _flutterTts.setLanguage(voice.language);
      await _flutterTts.setVoice({'name': voice.id, 'locale': voice.language});
      await _flutterTts.setSpeechRate(speed.clamp(0.5, 1.5));

      final completer = Completer<void>();
      _speechCompleter = completer;
      _flutterTts.setCompletionHandler(() {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
      _flutterTts.setErrorHandler((message) {
        if (!completer.isCompleted) {
          completer.completeError(Exception(message));
        }
      });

      isSpeaking.value = true;
      await _flutterTts.speak(text);
      await completer.future;
    } finally {
      if (_speechCompleter == completer) {
        _speechCompleter = null;
      }
      isSpeaking.value = false;
    }
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
