# TTS подсветка текста — текущее состояние и что чинить

## Что уже работает

- Озвучка идёт по чанкам до конца (авто-воспроизведение следующего чанка).
- Условие показа подсветки срабатывает на нужной вкладке: при воспроизведении на вкладке «Глубокое резюме» вокруг **всего** текста появляется зелёная рамка (добавлена для отладки в `summary_text_container.dart`). Значит, `showTtsHighlight == true` и код подсветки выполняется на правильном табе.
- Подсветка привязана к вкладке: показывается только на той вкладке, с которой нажали Play (tab 0 = источник, 1 = краткое, 2 = глубокое). См. комментарий у `_shouldShowTtsHighlight` и блок «Где смотреть подсветку» в [TTS_DEBUG_GUIDE.md](TTS_DEBUG_GUIDE.md).

## В чём проблема

Рамка и подсветка применяются ко **всему** тексту, а не к текущему куску/слову:

- Рамка рисуется вокруг всего `MarkdownBody` при `showTtsHighlight == true`, поэтому и охватывает весь текст — так и задумано для проверки.
- По задумке должны подсвечиваться: (1) уже проигранный текст (фон/цвет), (2) текущее слово (фон + оранжевое подчёркивание). Фактически пользователь не видит привязки к месту в тексте — выделяется всё или не то место.

Итог: **нет корреляции между воспроизведением и визуальным выделением конкретного фрагмента** (чанка или слова). Нужно чинить привязку подсветки к позиции в тексте.

## Где искать причину

1. **Расчёт позиции в тексте**  
   В [lib/screens/summary_screen/summary_text_container.dart](lib/screens/summary_screen/summary_text_container.dart) считаются `readEndIndex`, `currentWordStart`, `currentWordEnd` по `playbackPosition`, `playbackDuration` и `playbackContext` (fullText, chunk, playedUpToCharIndex). Проверить:
   - совпадение систем координат: `flattenedText` из `computeBlockOffsets(textToDisplay)` и текст в `playbackContext.fullText`;
   - что индексы не обнуляются/не теряются при смене чанка.

2. **Сопоставление блоков Markdown и координат**  
   В [lib/screens/summary_screen/markdown_tts_highlight_builder.dart](lib/screens/summary_screen/markdown_tts_highlight_builder.dart) для каждого блока (p, h1, …) берётся `blockStart` из `blockOffsets[_blockIndex]`. Эти оффсеты строятся в [markdown_tts_highlight_builder.dart](lib/screens/summary_screen/markdown_tts_highlight_builder.dart) через `computeBlockOffsets(textToDisplay)` на базе парсера пакета `markdown`. Возможные расхождения:
   - порядок обхода блоков в `MarkdownBody` (flutter_markdown_plus) и порядок блоков в `computeBlockOffsets` могут не совпадать;
   - разный парсинг/структура (например, другой состав блоков) → неверный `blockStart` → неверные `globalStart`/`globalEnd` и выделение не там или на всём тексте.

3. **Проверка по логам**  
   В логах ранее были строки вида  
   `[SummaryTextContainer] HIGHLIGHT_DEBUG: tab=2 ... readEnd=... word=...-...`  
   при включённом `_kLogHighlight`. Имеет смысл снова включить логи (`_kLogHighlight = true` в `summary_text_container.dart` и при необходимости в `tts_service.dart`), убедиться, что `readEndIndex` и границы слова меняются по мере воспроизведения и соответствуют ожидаемому месту в тексте.

## Что сделать в отдельном агенте

- Установить причину неверной привязки: либо координаты (readEnd/word) считаются неправильно, либо не совпадают с разметкой блоков (blockOffsets / порядок элементов).
- Исправить так, чтобы подсвечивались только уже проигранный диапазон и текущее слово (или текущий чанк, если решат упростить до подсветки по чанкам).
- После проверки убрать отладочную зелёную рамку вокруг всего текста в `summary_text_container.dart` (Container с `Border.all(color: Colors.green, ...)` при `showTtsHighlight`).

## Файлы, которые трогать

- [lib/screens/summary_screen/summary_text_container.dart](lib/screens/summary_screen/summary_text_container.dart) — расчёт `readEndIndex`/currentWord, условие подсветки, отладочная рамка.
- [lib/screens/summary_screen/markdown_tts_highlight_builder.dart](lib/screens/summary_screen/markdown_tts_highlight_builder.dart) — блоки, blockOffsets, отрисовка фона/подчёркивания по readEndIndex и currentWordStart/End.
- [lib/services/tts_service.dart](lib/services/tts_service.dart) — playbackContext (fullText, text, playedUpToCharIndex, chunkIndex), playbackPosition, playbackDuration.

## Кратко

- Подсветка «включена» на нужной вкладке (рамка вокруг всего текста это подтверждает).
- Нет корреляции «звук ↔ кусок/слово на экране» — нужно чинить привязку координат/блоков и затем убрать отладочную рамку.
