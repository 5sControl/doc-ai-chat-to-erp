# Отладка TTS: «играет только короткий текст» и «не работает подсветка»

Пошаговый план, чтобы по логам и поведению найти причину.

---

## Где смотреть подсветку при озвучке

Подсветка «проигранного» текста и текущего слова **включена только на той вкладке, с которой ты нажал Play**.

- **Вкладка «Источник» (tab 0)** — подсветка только если озвучку запустили с этой вкладки.
- **Вкладка «Краткое резюме» (tab 1)** — подсветка только если Play нажали на кратком.
- **Вкладка «Глубокое резюме» (tab 2)** — подсветка только если Play нажали на глубоком.

Это три разных экземпляра текста (три контрола). Не переключай вкладку после нажатия Play — смотри на той же вкладке, где играет озвучка. Если включён перевод (показан переведённый текст), подсветка не показывается — должен быть виден исходный текст.

---

## Что проверить по порядку

### 1. Разбиение на чанки (почему играет только начало)

Нужно понять: текст вообще режется на чанки или всегда один чанк.

**Добавь временные логи в `lib/services/tts_service.dart`:**

В методе `speak()`, сразу после блока с `chunkEntries` (около строки 648):

```dart
if (useTabCache) {
  final chunkEntries = chunkTextForTtsWithOffsets(trimmedFull);
  totalChunks = chunkEntries.length;
  debugPrint('[TtsService] CHUNK_DEBUG: textLength=${trimmedFull.length} totalChunks=$totalChunks chunkIndex=$chunkIndex');  // <-- добавить
  if (chunkIndex >= totalChunks) return;
  ...
}
```

**Что смотреть в логах при нажатии Play на вкладке «глубокое резюме»:**

- `textLength` — длина полного текста. Если там 200–300 символов, чанк будет один (лимит 250 на чанк).
- `totalChunks` — сколько чанков. Если всегда `1` — либо текст короткий, либо разбиение не срабатывает.
- Если `totalChunks >= 2`, но после первого куска ничего не происходит — смотреть пункт 2 (кнопка «Продолжить»).

**Где смотреть логи:**  
`flutter run` в терминале, или Xcode/Android Studio Console, или `adb logcat` (Android). Ищи строки с префиксом `[TtsService]`.

---

### 2. Кнопка «Продолжить» (почему не играет второй чанк)

Сейчас второй и следующие чанки играются только по нажатию «Продолжить», а не автоматически. Если кнопка не переключается на «Продолжить» после первого чанка — пользователь не может запустить второй.

**Логи в `lib/screens/summary_screen/share_copy_button.dart`:**

В `build` у `VoiceButton`, внутри `ValueListenableBuilder<int?>(valueListenable: service.nextChunkIndex, ...)`:

```dart
builder: (context, nextChunk, __) {
  final showContinue = !isLoading && !isSpeaking && nextChunk != null && _isSameSummaryAndTab(service);
  debugPrint('[VoiceButton] CONTINUE_DEBUG: nextChunk=$nextChunk isSpeaking=${service.isSpeaking.value} showContinue=$showContinue');  // <-- добавить
  ...
}
```

И добавь лог в `_isSameSummaryAndTab`:

```dart
bool _isSameSummaryAndTab(TtsService service) {
  final ctx = service.playbackContext.value;
  final ok = ctx != null && ctx.summaryKey == widget.summaryKey && ctx.activeTab == widget.activeTab;
  debugPrint('[VoiceButton] SAME_TAB_DEBUG: ctxKey=${ctx?.summaryKey} widgetKey=${widget.summaryKey} ctxTab=${ctx?.activeTab} widgetTab=${widget.activeTab} ok=$ok');
  return ok;
}
```

**Что смотреть:**

- После окончания первого чанка: появляется ли в логах `nextChunk=1` (или 2, 3…)?
- Если `nextChunk=1`, но `showContinue=false` — смотри `ok` в SAME_TAB_DEBUG: не совпадают ли `summaryKey` или `activeTab` (опечатка, разный тип, разное значение).
- Если после окончания воспроизведения `nextChunk` так и остаётся `null` — обработчик `onPlayerComplete` в TtsService не отрабатывает или не выставляет `nextChunkIndex`. Тогда добавить лог в `onPlayerComplete` в `tts_service.dart` (где выставляется `nextChunkIndex.value = chunkIndex + 1 ...`): например, `debugPrint('[TtsService] ON_COMPLETE: chunkIndex=$chunkIndex totalChunks=$totalChunks next=${chunkIndex + 1}');`.

---

### 3. Подсветка текущего слова

Подсветка должна показываться только **во время** воспроизведения (`isSpeaking == true`) и только для того же summary и вкладки.

**Логи в `lib/screens/summary_screen/summary_text_container.dart`:**

В блоке, где считается `showTtsHighlight` и дальше (около 281–320):

```dart
final showTtsHighlight = _isShowingOriginalText(widget.summaryTranslate) &&
    _shouldShowTtsHighlight(ttsService);

// добавить:
final ctx = ttsService.playbackContext.value;
debugPrint('[SummaryTextContainer] HIGHLIGHT_DEBUG: tabIndex=${widget.tabIndex} summaryKey=${widget.summaryKey} '
    'isSpeaking=${ttsService.isSpeaking.value} ctx=${ctx != null} '
    'match=${ctx?.summaryKey == widget.summaryKey && ctx?.activeTab == widget.tabIndex} '
    'showTtsHighlight=$showTtsHighlight');
```

Внутри блока `if (showTtsHighlight && flattenedText.isNotEmpty)` после вычисления `playedChars` / `readEndIndex` (если заходим в эту ветку):

```dart
debugPrint('[SummaryTextContainer] HIGHLIGHT_POS: pos=${ttsService.playbackPosition.value} dur=${ttsService.playbackDuration.value} '
    'fullLen=${ctx?.fullText?.length} flatLen=${flattenedText.length} readEndIndex=$readEndIndex currentWord=$currentWordStart-$currentWordEnd');
```

**Что смотреть:**

- `showTtsHighlight` — если при воспроизведении всегда `false`, подсветка не включится. Тогда смотреть: `isSpeaking`, совпадение `summaryKey` и `activeTab` с контекстом.
- Если `showTtsHighlight=true`, но подсветка не видна или не двигается: смотреть `HIGHLIGHT_POS`. Если `pos`/`dur` всегда null — события `onPositionChanged`/`onDurationChanged` от аудиоплеера не приходят (известная особенность на части платформ/режимов). Если `fullLen` и `flatLen` сильно отличаются — несовпадение текста (редко при не-demo, т.к. экран уже показывает getTransformedText).

---

## Краткий чеклист по логам

1. **Чанки:** при Play на длинном тексте в логе есть `CHUNK_DEBUG: textLength=... totalChunks=...` — записать значения.
2. **Продолжить:** после окончания первого куска есть ли `nextChunk=1` и `showContinue=true`; если нет — есть ли `SAME_TAB_DEBUG` и совпадают ли ключ/вкладка.
3. **Подсветка:** при воспроизведении есть ли `showTtsHighlight=true` и обновляются ли `pos`/`dur` в `HIGHLIGHT_POS`.

---

## Частые причины

| Симптом | Возможная причина |
|--------|--------------------|
| Всегда один чанк | Текст короткий (≤250 символов) или вызов speak без summaryKey/activeTab (useTabCache = false). |
| Не появляется «Продолжить» | После окончания чанка не выставляется nextChunkIndex (проверить onPlayerComplete) или _isSameSummaryAndTab даёт false (разные summaryKey/activeTab). |
| Подсветка не видна | _shouldShowTtsHighlight = false (другой таб/другой summary или isSpeaking уже false) или playbackPosition/playbackDuration не обновляются. |
| Подсветка не двигается | onPositionChanged не вызывается (ограничение плагина/платформы). |

---

## Что прислать для разбора

Если пришлёшь логи, вырежи кусок от нажатия Play на вкладке «глубокое резюме» до конца первого воспроизведения и (если жмёшь «Продолжить») до второго. Важно наличие строк:

- `[TtsService] CHUNK_DEBUG: ...`
- `[VoiceButton] CONTINUE_DEBUG: ...` и `SAME_TAB_DEBUG: ...`
- `[SummaryTextContainer] HIGHLIGHT_DEBUG: ...` и при наличии `HIGHLIGHT_POS: ...`

Плюс коротко: длина текста на вкладке «глубокое резюме» (примерно), появляется ли кнопка «Продолжить» после первого куска, на какой платформе тестируешь (iOS/Android).
