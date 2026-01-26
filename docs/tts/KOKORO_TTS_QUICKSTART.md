# Kokoro TTS - Быстрый старт

## Шаг 1: Подготовка файлов

1. Скачайте модель с Hugging Face:
   - Перейдите на https://huggingface.co/NeuML/kokoro-base-onnx
   - Скачайте `model.onnx` (~330 MB)
   - Скачайте `voices.json` (~52 MB)

2. Разместите файлы:
   ```
   assets/
     tts_models/
       kokoro/
         model.onnx
         voices.json
   ```

3. Добавьте в `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/tts_models/kokoro/model.onnx
       - assets/tts_models/kokoro/voices.json
       - assets/tokenizer_vocab.json
   ```

## Шаг 2: Генерация tokenizer_vocab.json

Запустите скрипт для создания правильного словаря токенизации:

```bash
python3 scripts/generate_tokenizer_vocab.py
```

Или вручную создайте файл `assets/tokenizer_vocab.json` используя Python:

```python
import json

vocab = {
    "$": 0,
    ";": 1,
    # ... (см. полный список в docs/KOKORO_TTS_INTEGRATION_PROMPT.md)
}

with open('assets/tokenizer_vocab.json', 'w', encoding='utf-8') as f:
    json.dump(vocab, f, indent=2, ensure_ascii=True, sort_keys=False)
```

**КРИТИЧЕСКИ ВАЖНО:** Используйте `ensure_ascii=True` - это обязательно для Dart JSON парсера!

## Шаг 3: Добавление зависимостей

Добавьте в `pubspec.yaml`:

```yaml
dependencies:
  kokoro_tts_flutter:
    git:
      url: https://github.com/your-username/kokoro_tts_flutter.git
  onnxruntime: ^1.15.0
  path_provider: ^2.1.0
  shared_preferences: ^2.2.0
  audioplayers: ^5.2.0
```

## Шаг 4: Базовая интеграция

```dart
import 'package:kokoro_tts_flutter/kokoro_tts_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Инициализация
final appDir = await getApplicationDocumentsDirectory();
final kokoro = await Kokoro.initialize(
  modelPath: '${appDir.path}/tts_models/kokoro/model.onnx',
  voicesPath: '${appDir.path}/tts_models/kokoro/voices.json',
);

// Синтез речи
final result = await kokoro.createTTS(
  text: "Hello, world!",
  voice: "af",
  lang: "en-us",
  speed: 1.0,
);

// Воспроизведение аудио
// (используйте ваш аудио плеер)
```

## Шаг 5: Копирование файлов модели

Перед использованием скопируйте файлы из assets в рабочую директорию:

```dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> copyModelFiles() async {
  final appDir = await getApplicationDocumentsDirectory();
  final modelDir = Directory('${appDir.path}/tts_models/kokoro');
  await modelDir.create(recursive: true);

  // Копируйте model.onnx
  final modelData = await rootBundle.load('assets/tts_models/kokoro/model.onnx');
  await File('${modelDir.path}/model.onnx')
      .writeAsBytes(modelData.buffer.asUint8List());

  // Копируйте voices.json
  final voicesData = await rootBundle.load('assets/tts_models/kokoro/voices.json');
  await File('${modelDir.path}/voices.json')
      .writeAsBytes(voicesData.buffer.asUint8List());
}
```

## Проверка токенизации

Для проверки правильности токенизации используйте готовый скрипт:

```bash
cd test_kokoro
pip install -r requirements.txt
python test_kokoro_tokens.py
```

Скрипт выведет эталонные токены для сравнения с логами Flutter приложения.

## Типичные ошибки

### ❌ FormatException: Unexpected character
**Причина:** Неправильный формат JSON (буквальные Unicode символы вместо escape sequences)
**Решение:** Используйте `ensure_ascii=True` при создании JSON

### ❌ Model files not found
**Причина:** Файлы не скопированы из assets
**Решение:** Вызовите `copyModelFiles()` перед инициализацией

### ❌ Аудио звучит как "абра-кадабра"
**Причина:** Неправильный словарь токенизации
**Решение:** 
1. Используйте правильный `tokenizer_vocab.json` из IPATokenizer
2. Проверьте токены с помощью `test_kokoro/test_kokoro_tokens.py` - они должны совпадать с логами Flutter

## Полная документация

Для детальной информации см. [KOKORO_TTS_INTEGRATION_PROMPT.md](./KOKORO_TTS_INTEGRATION_PROMPT.md)
