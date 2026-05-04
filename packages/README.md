# `packages/` — локальные Dart-пакеты

Здесь лежат **вендоренные** (скопированные в репозиторий) зависимости, которые мы правим под Summify.

| Папка | Назначение |
|--------|------------|
| **`vendored_kokoro_tts_flutter`** | Форк `kokoro_tts_flutter`: загрузка `voices.json` с диска для скачанных моделей (upstream всегда вызывал `rootBundle`, из‑за чего падало на абсолютных путях). Имя пакета в коде остаётся `kokoro_tts_flutter` — меняется только путь в корневом `pubspec.yaml`. |

Подробности патча: `vendored_kokoro_tts_flutter/FOR_SUMMIFY_MAINTAINERS.md`.
