# Kokoro TTS Tokenization Test

Этот скрипт помогает сравнить токенизацию с официальной реализацией IPATokenizer.

## Установка

```bash
cd test_kokoro
pip install -r requirements.txt
```

Если IPATokenizer добавлен в workspace, скрипт автоматически его найдет.
Иначе установите:
```bash
pip install ttstokenizer
```

## Использование

### Базовый тест (только токенизация)

```bash
python test_kokoro_tokens.py
```

Это выведет токены для фразы "Because I fell in love." в формате, который можно сравнить с логами Flutter приложения.

### Полный тест (с моделью ONNX)

Если у вас есть файлы модели, скрипт автоматически найдет их в:
- `test_kokoro/model.onnx` и `test_kokoro/voices.json`
- `../model.onnx` и `../voices.json` (родительская директория)
- `../tts_models/kokoro/model.onnx` и `../tts_models/kokoro/voices.json`
- `~/Downloads/model.onnx` (папка загрузок)

Скрипт также:
1. Загрузит модель ONNX
2. Сгенерирует аудио с помощью официальной реализации
3. Сохранит результат в `test_output.wav` для сравнения

## Сравнение результатов

1. Запустите этот скрипт и скопируйте токены
2. Запустите Flutter приложение с той же фразой "Because I fell in love."
3. Сравните токены в логах:
   - Если токены **совпадают** → проблема в другом месте (модель, style vector, конвертация аудио)
   - Если токены **отличаются** → проблема в токенизации, нужно исправить `tokenizer_vocab.json` или алгоритм токенизации

## Пример вывода

```
============================================================
Kokoro TTS Tokenization Test
============================================================

Test phrase: "Because I fell in love."
------------------------------------------------------------

Tokens (from IPATokenizer):
  Raw tokens: [109, 93, 115, 120, 92, 115, ...]
  Token count: 25

Tokens with padding [0, *tokens, 0]:
  [0, 109, 93, 115, 120, 92, 115, ..., 0]
  Total length: 27

For Flutter comparison (copy this):
  Expected tokens: [109, 93, 115, 120, 92, 115, ...]
  Expected padded: [0, 109, 93, 115, 120, 92, 115, ..., 0]
```

Сравните эти токены с логами Flutter приложения!
