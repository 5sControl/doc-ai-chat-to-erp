# Kokoro TTS - Быстрый старт

## ⚠️ ВАЖНО: Перед началом

**НЕ используйте оригинальный пакет из pub.dev!** 

Вам нужно:
1. Скопировать папку `lib/patches/kokoro_tts_flutter_patched/` из этого проекта
2. Использовать `path:` в pubspec.yaml, а НЕ `git:` или версию из pub.dev

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

3. Скопируйте файлы фонетизации (ОБЯЗАТЕЛЬНО):
   - `assets/us_gold.json` - словарь фонетизации (~2-3 MB)
   - `assets/us_silver.json` - словарь фонетизации (~200-300 KB)
   
   Эти файлы нужны для преобразования английского текста в фонемы.

4. Добавьте в `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/tts_models/kokoro/model.onnx
       - assets/tts_models/kokoro/voices.json
       - assets/tokenizer_vocab.json
       - assets/us_gold.json      # ОБЯЗАТЕЛЬНО
       - assets/us_silver.json    # ОБЯЗАТЕЛЬНО
       - assets/lexicon.json      # Опционально
   ```

## Шаг 2: Копирование файлов фонетизации

**КРИТИЧЕСКИ ВАЖНО:** Скопируйте файлы `us_gold.json` и `us_silver.json` из этого проекта!

Эти файлы используются библиотекой `malsami` для фонетизации английского текста. Без них библиотека не сможет преобразовать текст в фонемы.

**Что копировать:**
- `assets/us_gold.json` (~2-3 MB) - словарь высококачественной фонетизации
- `assets/us_silver.json` (~200-300 KB) - словарь базовой фонетизации

**Куда копировать:**
```
ваш_проект/
  assets/
    us_gold.json
    us_silver.json
```

**Откуда взять:**
1. Скопируйте из этого проекта (рекомендуется)
2. Или установите пакет `malsami` и скопируйте из `packages/malsami/assets/`

## Шаг 3: Генерация tokenizer_vocab.json

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

## Шаг 3: Копирование патченной библиотеки

**ВАЖНО:** Не используйте оригинальный пакет из pub.dev! Нужно скопировать патченную версию.

1. Скопируйте папку `lib/patches/kokoro_tts_flutter_patched/` из этого проекта в ваш проект:
   ```
   ваш_проект/
     lib/
       patches/
         kokoro_tts_flutter_patched/
           (всю папку)
   ```

2. Добавьте в `pubspec.yaml`:

```yaml
dependencies:
  # Используйте локальный путь к патченной библиотеке
  kokoro_tts_flutter:
    path: lib/patches/kokoro_tts_flutter_patched
  
  # Остальные зависимости
  onnxruntime: ^1.15.0
  path_provider: ^2.1.0
  shared_preferences: ^2.2.0
  audioplayers: ^5.2.0
```

3. Выполните:
```bash
flutter pub get
```

**Почему не git URL?**
- Патченная версия содержит исправления и логирование
- Оригинальная версия из pub.dev может не работать правильно
- Используйте локальный путь `path:` вместо `git:`

## Шаг 5: Базовая интеграция

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

## Шаг 6: Копирование файлов модели

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

### ❌ Ошибка: "Failed to load us_gold.json" или "us_gold.json required for phonemization"
**Причина:** Отсутствуют файлы фонетизации
**Решение:** 
1. Скопируйте `assets/us_gold.json` и `assets/us_silver.json` из этого проекта
2. Добавьте их в `pubspec.yaml` в секцию `assets:`
3. Выполните `flutter clean && flutter pub get`
4. Перезапустите приложение

## Полная документация

Для детальной информации см. [KOKORO_TTS_INTEGRATION_PROMPT.md](./KOKORO_TTS_INTEGRATION_PROMPT.md)
