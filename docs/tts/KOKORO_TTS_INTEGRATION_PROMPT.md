# Промпт для интеграции Kokoro TTS в Flutter приложение

## Цель
Добавить синтез речи на базе модели Kokoro TTS (ONNX) в Flutter приложение с правильной токенизацией и настройками.

---

## 1. Подготовка файлов модели

### 1.1 Скачивание модели и словаря

**Источник модели:**
- URL: https://huggingface.co/NeuML/kokoro-base-onnx
- Необходимые файлы:
  - `model.onnx` (~330 MB)
  - `voices.json` (~52 MB)

**Размещение файлов:**
```
assets/
  tts_models/
    kokoro/
      model.onnx
      voices.json
```

**ВАЖНО:** Файлы должны быть добавлены в `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/tts_models/kokoro/model.onnx
    - assets/tts_models/kokoro/voices.json
    - assets/tokenizer_vocab.json
    - assets/lexicon.json  # Опционально, но рекомендуется
```

---

## 2. Словарь токенизации (tokenizer_vocab.json)

### 2.1 КРИТИЧЕСКИ ВАЖНО: Правильный формат JSON

**Проблема:** Dart JSON парсер не поддерживает буквальные Unicode символы в ключах JSON. Все не-ASCII символы должны быть представлены как Unicode escape sequences (`\uXXXX`).

**Решение:** Используйте `ensure_ascii=True` при создании JSON файла через Python.

### 2.2 Создание правильного tokenizer_vocab.json

Создайте файл `assets/tokenizer_vocab.json` используя следующий Python скрипт:

```python
import json

# Словарь токенизации из IPATokenizer (ttstokenizer)
# Структура: pad -> punctuation -> letters -> IPA letters
vocab = {
    "$": 0,           # pad token
    ";": 1,
    ":": 2,
    ",": 3,
    ".": 4,
    "!": 5,
    "?": 6,
    "\u00a1": 7,      # ¡ (inverted exclamation)
    "\u00bf": 8,      # ¿ (inverted question)
    "\u2014": 9,      # — (em dash)
    "\u2026": 10,     # … (ellipsis)
    "\"": 11,         # " (straight quote)
    "\u00ab": 12,     # « (left guillemet)
    "\u00bb": 13,     # » (right guillemet)
    "\u201c": 14,     # " (left double quotation mark)
    "\u201d": 15,     # " (right double quotation mark)
    " ": 16,          # space
    
    # Uppercase letters A-Z
    "A": 17, "B": 18, "C": 19, "D": 20, "E": 21, "F": 22, "G": 23, "H": 24,
    "I": 25, "J": 26, "K": 27, "L": 28, "M": 29, "N": 30, "O": 31, "P": 32,
    "Q": 33, "R": 34, "S": 35, "T": 36, "U": 37, "V": 38, "W": 39, "X": 40,
    "Y": 41, "Z": 42,
    
    # Lowercase letters a-z
    "a": 43, "b": 44, "c": 45, "d": 46, "e": 47, "f": 48, "g": 49, "h": 50,
    "i": 51, "j": 52, "k": 53, "l": 54, "m": 55, "n": 56, "o": 57, "p": 58,
    "q": 59, "r": 60, "s": 61, "t": 62, "u": 63, "v": 64, "w": 65, "x": 66,
    "y": 67, "z": 68,
    
    # IPA letters (все должны быть в Unicode escape формате!)
    "\u0251": 69,   # ɑ
    "\u0250": 70,   # ɐ
    "\u0252": 71,   # ɒ
    "\u00e6": 72,   # æ
    "\u0253": 73,   # ɓ
    "\u0299": 74,   # ʙ
    "\u03b2": 75,   # β
    "\u0254": 76,   # ɔ
    "\u0255": 77,   # ɕ
    "\u00e7": 78,   # ç
    "\u0257": 79,   # ɗ
    "\u0256": 80,   # ɖ
    "\u00f0": 81,   # ð
    "\u02a4": 82,   # ʤ
    "\u0259": 83,   # ə
    "\u0258": 84,   # ɘ
    "\u025a": 85,   # ɚ
    "\u025b": 86,   # ɛ
    "\u025c": 87,   # ɜ
    "\u025d": 88,   # ɝ
    "\u025e": 89,   # ɞ
    "\u025f": 90,   # ɟ
    "\u0284": 91,   # ʄ
    "\u0261": 92,   # ɡ
    "\u0260": 93,   # ɠ
    "\u0262": 94,   # ɢ
    "\u029b": 95,   # ʛ
    "\u0266": 96,   # ɦ
    "\u0267": 97,   # ɧ
    "\u0127": 98,   # ħ
    "\u0265": 99,   # ɥ
    "\u029c": 100,  # ʜ
    "\u0268": 101,  # ɨ
    "\u026a": 102,  # ɪ
    "\u029d": 103,  # ʝ
    "\u026d": 104,  # ɭ
    "\u026c": 105,  # ɬ
    "\u026b": 106,  # ɫ
    "\u026e": 107,  # ɮ
    "\u029f": 108,  # ʟ
    "\u0271": 109,  # ɱ
    "\u026f": 110,  # ɯ
    "\u0270": 111,  # ɰ
    "\u014b": 112,  # ŋ
    "\u0273": 113,  # ɳ
    "\u0272": 114,  # ɲ
    "\u0274": 115,  # ɴ
    "\u00f8": 116,  # ø
    "\u0275": 117,  # ɵ
    "\u0278": 118,  # ɸ
    "\u03b8": 119,  # θ
    "\u0153": 120,  # œ
    "\u0276": 121,  # ɶ
    "\u0298": 122,  # ʘ
    "\u0279": 123,  # ɹ
    "\u027a": 124,  # ɺ
    "\u027e": 125,  # ɾ
    "\u027b": 126,  # ɻ
    "\u0280": 127,  # ʀ
    "\u0281": 128,  # ʁ
    "\u027d": 129,  # ɽ
    "\u0282": 130,  # ʂ
    "\u0283": 131,  # ʃ
    "\u0288": 132,  # ʈ
    "\u02a7": 133,  # ʧ
    "\u0289": 134,  # ʉ
    "\u028a": 135,  # ʊ
    "\u028b": 136,  # ʋ
    "\u2c71": 137,  # ⱱ
    "\u028c": 138,  # ʌ
    "\u0263": 139,  # ɣ
    "\u0264": 140,  # ɤ
    "\u028d": 141,  # ʍ
    "\u03c7": 142,  # χ
    "\u028e": 143,  # ʎ
    "\u028f": 144,  # ʏ
    "\u0291": 145,  # ʑ
    "\u0290": 146,  # ʐ
    "\u0292": 147,  # ʒ
    "\u0294": 148,  # ʔ
    "\u02a1": 149,  # ʡ
    "\u0295": 150,  # ʕ
    "\u02a2": 151,  # ʢ
    "\u01c0": 152,  # ǀ
    "\u01c1": 153,  # ǁ
    "\u01c2": 154,  # ǂ
    "\u01c3": 155,  # ǃ
    "\u02c8": 156,  # ˈ (primary stress)
    "\u02cc": 157,  # ˌ (secondary stress)
    "\u02d0": 158,  # ː (long)
    "\u02d1": 159,  # ˑ (half-long)
    "\u02bc": 160,  # ʼ (ejective)
    "\u02b4": 161,  # ʴ (rhoticity)
    "\u02b0": 162,  # ʰ (aspirated)
    "\u02b1": 163,  # ʱ (breathy voiced)
    "\u02b2": 164,  # ʲ (palatalized)
    "\u02b7": 165,  # ʷ (labialized)
    "\u02e0": 166,  # ˠ (velarized)
    "\u02e4": 167,  # ˤ (pharyngealized)
    "\u02de": 168,  # ˞ (rhoticity)
    "\u2193": 169,  # ↓ (downstep)
    "\u2191": 170,  # ↑ (upstep)
    "\u2192": 171,  # → (right arrow)
    "\u2197": 172,  # ↗ (up-right arrow)
    "\u2198": 173,  # ↘ (down-right arrow)
    "'": 176,        # apostrophe
    "\u0329": 175,  # ̩ (syllabic)
    "\u1d7b": 177,   # ᵻ (near-close central unrounded)
}

# КРИТИЧЕСКИ ВАЖНО: используйте ensure_ascii=True для правильного экранирования
with open('assets/tokenizer_vocab.json', 'w', encoding='utf-8') as f:
    json.dump(vocab, f, indent=2, ensure_ascii=True, sort_keys=False)

print("✓ tokenizer_vocab.json created successfully")
print(f"Total entries: {len(vocab)}")
```

**ВАЖНО:** 
- Всегда используйте `ensure_ascii=True` при создании JSON
- Не используйте буквальные Unicode символы в ключах JSON
- Проверьте валидность JSON после создания: `python3 -m json.tool assets/tokenizer_vocab.json`

---

## 3. Зависимости (pubspec.yaml)

Добавьте следующие зависимости:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Kokoro TTS (используйте патченную версию или форк)
  kokoro_tts_flutter:
    git:
      url: https://github.com/your-username/kokoro_tts_flutter.git
      # Или используйте локальный путь:
      # path: ../kokoro_tts_flutter_patched
  
  # Для работы с ONNX
  onnxruntime: ^1.15.0
  
  # Для работы с файлами и путями
  path_provider: ^2.1.0
  
  # Для хранения настроек
  shared_preferences: ^2.2.0
  
  # Для работы с аудио
  audioplayers: ^5.2.0
  # или
  just_audio: ^0.9.36
  
  # Для работы с JSON
  # (встроен в Flutter, но может понадобиться для кастомных парсеров)

dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

## 4. Структура проекта

```
lib/
  data/
    datasources/
      storage/
        tts_settings_datasource.dart  # Хранение настроек TTS
      tts/
        kokoro_tts_engine.dart       # Обертка для Kokoro TTS
        tts_datasource.dart           # Основной источник TTS
    repositories/
      tts_repository.dart              # Репозиторий TTS
  core/
    constants/
      app_constants.dart               # Константы (включая ключи настроек)
  presentation/
    providers/
      tts_provider.dart                # Провайдер состояния TTS
    screens/
      settings/
        widgets/
          tts_settings_section.dart    # UI для настроек TTS
```

---

## 5. Константы (app_constants.dart)

Добавьте следующие константы:

```dart
class AppConstants {
  // ... другие константы ...
  
  // TTS Settings Keys
  static const String keyTtsLanguage = 'tts_language';
  static const String keyTtsSpeechRate = 'tts_speech_rate';
  static const String keyTtsVolume = 'tts_volume';
  static const String keyTtsPitch = 'tts_pitch';
  static const String keyTtsEngineType = 'tts_engine_type';
  static const String keyKokoroVoiceId = 'kokoro_voice_id';
  static const String keyKokoroSynthesisSpeed = 'kokoro_synthesis_speed';
  
  // TTS Defaults
  static const String defaultTtsLanguage = 'en-US';
  static const double defaultTtsSpeechRate = 1.0;
  static const double defaultTtsVolume = 1.0;
  static const double defaultTtsPitch = 1.0;
  static const String defaultTtsEngineType = 'kokoro';
  static const String defaultKokoroVoiceId = 'af';
  static const double defaultKokoroSynthesisSpeed = 1.0;
}
```

---

## 6. TTS Settings Datasource

Создайте файл `lib/data/datasources/storage/tts_settings_datasource.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app/core/constants/app_constants.dart';

class TtsSettingsDatasource {
  final SharedPreferences _prefs;

  TtsSettingsDatasource(this._prefs);

  // Language
  Future<String> getLanguage() async {
    return _prefs.getString(AppConstants.keyTtsLanguage) ?? 
           AppConstants.defaultTtsLanguage;
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString(AppConstants.keyTtsLanguage, language);
  }

  // Speech Rate
  Future<double> getSpeechRate() async {
    return _prefs.getDouble(AppConstants.keyTtsSpeechRate) ?? 
           AppConstants.defaultTtsSpeechRate;
  }

  Future<void> setSpeechRate(double rate) async {
    await _prefs.setDouble(AppConstants.keyTtsSpeechRate, rate);
  }

  // Volume
  Future<double> getVolume() async {
    return _prefs.getDouble(AppConstants.keyTtsVolume) ?? 
           AppConstants.defaultTtsVolume;
  }

  Future<void> setVolume(double volume) async {
    await _prefs.setDouble(AppConstants.keyTtsVolume, volume);
  }

  // Pitch
  Future<double> getPitch() async {
    return _prefs.getDouble(AppConstants.keyTtsPitch) ?? 
           AppConstants.defaultTtsPitch;
  }

  Future<void> setPitch(double pitch) async {
    await _prefs.setDouble(AppConstants.keyTtsPitch, pitch);
  }

  // Engine Type
  Future<String> getEngineType() async {
    return _prefs.getString(AppConstants.keyTtsEngineType) ?? 
           AppConstants.defaultTtsEngineType;
  }

  Future<void> setEngineType(String engineType) async {
    await _prefs.setString(AppConstants.keyTtsEngineType, engineType);
  }

  // Kokoro Voice ID
  Future<String> getKokoroVoiceId() async {
    return _prefs.getString(AppConstants.keyKokoroVoiceId) ?? 
           AppConstants.defaultKokoroVoiceId;
  }

  Future<void> setKokoroVoiceId(String voiceId) async {
    await _prefs.setString(AppConstants.keyKokoroVoiceId, voiceId);
  }

  // Kokoro Synthesis Speed
  Future<double> getKokoroSynthesisSpeed() async {
    return _prefs.getDouble(AppConstants.keyKokoroSynthesisSpeed) ?? 
           AppConstants.defaultKokoroSynthesisSpeed;
  }

  Future<void> setKokoroSynthesisSpeed(double speed) async {
    await _prefs.setDouble(AppConstants.keyKokoroSynthesisSpeed, speed);
  }
}
```

---

## 7. Kokoro TTS Engine Wrapper

Создайте файл `lib/data/datasources/tts/kokoro_tts_engine.dart`:

```dart
import 'dart:io';
import 'package:kokoro_tts_flutter/kokoro_tts_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_app/data/datasources/storage/tts_settings_datasource.dart';
import 'package:your_app/core/constants/app_constants.dart';

class KokoroTtsEngine {
  Kokoro? _kokoro;
  final TtsSettingsDatasource _settingsDatasource;
  double _synthesisSpeed = 1.0;

  KokoroTtsEngine(this._settingsDatasource);

  Future<void> initialize() async {
    try {
      // Загрузите настройки
      _synthesisSpeed = await _settingsDatasource.getKokoroSynthesisSpeed();
      
      // Получите путь к файлам модели
      final appDir = await getApplicationDocumentsDirectory();
      final modelPath = '${appDir.path}/tts_models/kokoro/model.onnx';
      final voicesPath = '${appDir.path}/tts_models/kokoro/voices.json';
      
      // Проверьте существование файлов
      if (!await File(modelPath).exists() || 
          !await File(voicesPath).exists()) {
        throw Exception('Model files not found. Please ensure model.onnx and voices.json are in the app directory.');
      }

      // Инициализируйте Kokoro
      _kokoro = await Kokoro.initialize(
        modelPath: modelPath,
        voicesPath: voicesPath,
      );

      // Проверьте доступные голоса
      final selectedVoiceId = await _settingsDatasource.getKokoroVoiceId();
      if (!_kokoro!.availableVoices.contains(selectedVoiceId)) {
        print('Warning: Selected voice $selectedVoiceId not found. Using first available voice.');
      }
    } catch (e) {
      throw Exception('Failed to initialize Kokoro TTS: $e');
    }
  }

  Future<Uint8List> synthesize(String text, {
    String? language,
    double? speed,
  }) async {
    if (_kokoro == null) {
      throw Exception('Kokoro TTS not initialized');
    }

    final voiceId = await _settingsDatasource.getKokoroVoiceId();
    final langCode = language ?? await _settingsDatasource.getLanguage();
    final synthesisSpeed = speed ?? _synthesisSpeed;

    try {
      // Вызовите синтез
      final result = await _kokoro!.createTTS(
        text: text,
        voice: voiceId,
        lang: langCode,
        speed: synthesisSpeed,
      );

      // Извлеките аудио данные
      final audioData = result.audio;
      final sampleRate = result.sampleRate;

      // Конвертируйте Float32List в PCM16
      final pcmData = _convertFloat32ToPCM16(audioData, sampleRate);

      return pcmData;
    } catch (e) {
      throw Exception('Failed to synthesize speech: $e');
    }
  }

  Uint8List _convertFloat32ToPCM16(Float32List floatList, int sampleRate) {
    final pcmData = Uint8List(floatList.length * 2);
    final buffer = pcmData.buffer.asInt16List();

    for (int i = 0; i < floatList.length; i++) {
      // Ограничьте значение в диапазоне [-1.0, 1.0]
      double sample = floatList[i].clamp(-1.0, 1.0);
      
      // Конвертируйте в 16-bit signed integer
      buffer[i] = (sample * 32767.0).round().clamp(-32768, 32767);
    }

    return pcmData;
  }

  List<String> getAvailableVoices() {
    return _kokoro?.availableVoices ?? [];
  }

  void dispose() {
    _kokoro = null;
  }
}
```

---

## 8. Копирование файлов модели в приложение

Создайте функцию для копирования файлов модели из assets в рабочую директорию:

```dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> copyModelFiles() async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${appDir.path}/tts_models/kokoro');
    
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }

    // Копируйте model.onnx
    final modelFile = File('${modelDir.path}/model.onnx');
    if (!await modelFile.exists()) {
      final modelData = await rootBundle.load('assets/tts_models/kokoro/model.onnx');
      await modelFile.writeAsBytes(modelData.buffer.asUint8List());
    }

    // Копируйте voices.json
    final voicesFile = File('${modelDir.path}/voices.json');
    if (!await voicesFile.exists()) {
      final voicesData = await rootBundle.load('assets/tts_models/kokoro/voices.json');
      await voicesFile.writeAsBytes(voicesData.buffer.asUint8List());
    }
  } catch (e) {
    throw Exception('Failed to copy model files: $e');
  }
}
```

Вызовите эту функцию при инициализации приложения (например, в `main()` или в `initState` главного виджета).

---

## 9. UI для настроек TTS

Создайте виджет настроек `lib/presentation/screens/settings/widgets/tts_settings_section.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/presentation/providers/tts_provider.dart';

class TtsSettingsSection extends StatefulWidget {
  final TtsProvider ttsProvider;

  const TtsSettingsSection({required this.ttsProvider});

  @override
  State<TtsSettingsSection> createState() => _TtsSettingsSectionState();
}

class _TtsSettingsSectionState extends State<TtsSettingsSection> {
  String? _selectedLanguage;
  String? _selectedVoice;
  double _speechRate = 1.0;
  double _volume = 1.0;
  double _pitch = 1.0;
  double _synthesisSpeed = 1.0;
  String? _engineType;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await widget.ttsProvider.getSettings();
    setState(() {
      _selectedLanguage = settings.language;
      _selectedVoice = settings.kokoroVoiceId;
      _speechRate = settings.speechRate;
      _volume = settings.volume;
      _pitch = settings.pitch;
      _synthesisSpeed = settings.kokoroSynthesisSpeed;
      _engineType = settings.engineType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Language selection
        ListTile(
          title: Text('Language'),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: ['en-US', 'en-GB', 'es-ES', 'fr-FR'].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (value) async {
              if (value != null) {
                await widget.ttsProvider.setLanguage(value);
                _loadSettings();
              }
            },
          ),
        ),
        
        // Voice selection (только для Kokoro)
        if (_engineType == 'kokoro')
          ListTile(
            title: Text('Voice'),
            trailing: FutureBuilder<List<String>>(
              future: widget.ttsProvider.getAvailableVoices(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return DropdownButton<String>(
                  value: _selectedVoice,
                  items: snapshot.data!.map((voice) {
                    return DropdownMenuItem(
                      value: voice,
                      child: Text(voice),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await widget.ttsProvider.setKokoroVoiceId(value);
                      _loadSettings();
                    }
                  },
                );
              },
            ),
          ),
        
        // Speech Rate
        ListTile(
          title: Text('Speech Rate'),
          trailing: Slider(
            value: _speechRate,
            min: 0.5,
            max: 2.0,
            divisions: 30,
            onChanged: (value) async {
              await widget.ttsProvider.setSpeechRate(value);
              _loadSettings();
            },
          ),
        ),
        
        // Volume
        ListTile(
          title: Text('Volume'),
          trailing: Slider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (value) async {
              await widget.ttsProvider.setVolume(value);
              _loadSettings();
            },
          ),
        ),
        
        // Pitch
        ListTile(
          title: Text('Pitch (voice tone)'),
          trailing: Slider(
            value: _pitch,
            min: 0.5,
            max: 2.0,
            divisions: 30,
            onChanged: (value) async {
              await widget.ttsProvider.setPitch(value);
              _loadSettings();
            },
          ),
        ),
        
        // Synthesis Speed (только для Kokoro)
        if (_engineType == 'kokoro')
          ListTile(
            title: Text('Synthesis Speed (voice speed)'),
            trailing: Slider(
              value: _synthesisSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 30,
              onChanged: (value) async {
                await widget.ttsProvider.setKokoroSynthesisSpeed(value);
                _loadSettings();
              },
            ),
          ),
      ],
    );
  }
}
```

---

## 10. Типичные проблемы и решения

### Проблема 1: JSON parsing error с Unicode символами
**Симптом:** `FormatException: Unexpected character`
**Решение:** Используйте `ensure_ascii=True` при создании JSON файла через Python

### Проблема 2: Модель не найдена
**Симптом:** `Model files not found`
**Решение:** Убедитесь, что файлы скопированы из assets в рабочую директорию перед инициализацией

### Проблема 3: Неправильные токены
**Симптом:** Аудио звучит как "абра-кадабра"
**Решение:** Убедитесь, что `tokenizer_vocab.json` использует правильный словарь из IPATokenizer с Unicode escape sequences

### Проблема 4: Голос не найден
**Симптом:** `Selected voice not found`
**Решение:** Проверьте доступные голоса через `_kokoro!.availableVoices` и используйте существующий ID

### Проблема 5: Sample rate mismatch
**Симптом:** Аудио воспроизводится с неправильной скоростью
**Решение:** Используйте `sampleRate` из результата `createTTS`, а не фиксированное значение

---

## 11. Проверка правильности интеграции

### Тест токенизации

Создайте тестовый скрипт для проверки токенизации:

```python
from ttstokenizer import IPATokenizer

tokenizer = IPATokenizer()
text = "Because I fell in love."
tokens = tokenizer(text)
print(f"Expected tokens: {list(tokens)}")
```

Затем сравните с логами Flutter приложения - токены должны совпадать.

### Тест синтеза

Протестируйте синтез простой фразы и проверьте:
1. Аудио файл создается
2. Аудио воспроизводится
3. Качество звука приемлемое
4. Скорость соответствует настройкам

---

## 12. Дополнительные рекомендации

1. **Логирование:** Добавьте подробное логирование для отладки:
   - Токены до и после токенизации
   - Метаданные голоса
   - Параметры синтеза
   - Статистика аудио (min/max/avg)

2. **Обработка ошибок:** Всегда обрабатывайте ошибки инициализации и синтеза

3. **Производительность:** Кэшируйте инициализацию Kokoro, не создавайте новый экземпляр для каждого синтеза

4. **Память:** Освобождайте ресурсы при закрытии приложения через `dispose()`

5. **Настройки по умолчанию:** Используйте разумные значения по умолчанию для всех параметров

---

## 13. Чеклист интеграции

- [ ] Скачаны файлы модели (`model.onnx`, `voices.json`)
- [ ] Файлы добавлены в `assets/` и `pubspec.yaml`
- [ ] Создан `tokenizer_vocab.json` с правильными Unicode escape sequences
- [ ] Добавлены все зависимости в `pubspec.yaml`
- [ ] Создан `TtsSettingsDatasource` для хранения настроек
- [ ] Создан `KokoroTtsEngine` wrapper
- [ ] Реализована функция копирования файлов модели
- [ ] Создан UI для настроек TTS
- [ ] Добавлены константы в `AppConstants`
- [ ] Протестирована токенизация (сравнение с IPATokenizer)
- [ ] Протестирован синтез речи
- [ ] Добавлена обработка ошибок
- [ ] Добавлено логирование для отладки

---

## Заключение

Следуя этому промпту, вы сможете успешно интегрировать Kokoro TTS в любое Flutter приложение. Главные моменты:

1. **Правильный формат JSON** - всегда используйте Unicode escape sequences
2. **Правильный словарь токенизации** - должен совпадать с IPATokenizer
3. **Правильная инициализация** - копируйте файлы модели перед использованием
4. **Правильные настройки** - используйте все параметры синтеза

Удачи с интеграцией! 🚀
