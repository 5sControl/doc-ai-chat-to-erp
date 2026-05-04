# Vendored Kokoro TTS — что это и зачем

## Зачем вендор

Оригинальный пакет **kokoro_tts_flutter** (pub.dev) в `Kokoro._loadVoices()` всегда вызывал `rootBundle.loadString(voicesPath)`.  
После скачивания модели Summify передаёт **абсолютный путь** к `app_flutter/.../voices.json` → Flutter отвечал `Unable to load asset: "/data/..."` и падал Kokoro.

## Что изменено (Summify patch)

- **`lib/src/kokoro.dart`**: если путь похож на Flutter asset (`assets/…`, `packages/…`) — `rootBundle`; иначе — чтение с диска через условный импорт.
- **`lib/src/kokoro_voices_read_from_disk_io.dart`**: реализация для VM/мобильных/desktop (`dart:io`).
- **`lib/src/kokoro_voices_read_from_disk_stub.dart`**: заглушка для web (без `dart:io`).

Версия пакета в `pubspec.yaml`: `0.2.0+1-summify.1` (на базе upstream **0.2.0+1**).

## Как обновить с upstream

1. Скачать новую версию из pub.dev или с GitHub автора.
2. Перенести наши три файла/изменения (`kokoro.dart` + два `kokoro_voices_read_from_disk_*.dart`).
3. Поднять суффикс версии (например `summify.2`) и прогнать `flutter pub get` + сборку.

## Имя папки

`vendored_kokoro_tts_flutter` — намеренно длинное имя: сразу видно, что это **не** случайная копия, а зависимость с правками под продукт.
