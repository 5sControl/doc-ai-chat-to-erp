# Все URL и эндпоинты, используемые в приложении Summify

Документ перечисляет все внешние URL и API-эндпоинты, которые использует приложение. При переходе на новый сервер для API нужно обновить соответствующие базовые URL и пути.

---

## 1. API Summify (документы, парсинг, LLM)

**Сервер:** один активный хост; цепочка fallback заложена в коде, но **закомментирована** (см. `lib/services/summaryApi.dart`).

| Назначение | Базовый URL | Файл |
|------------|-------------|------|
| Основной (активен) | `https://api.lmnotebookpro.com` | `lib/services/summaryApi.dart` (`_baseUrlPrimary`) |

**Запланированные fallback-хосты** (тот же префикс путей `/api/v1/...`; включить — раскомментировать `_fallbackBaseUrls` и блок в `_postWithFallback`):

1. `https://api.employees-training.com`
2. `https://chromium.employees-training.com`

**Эндпоинты (пути добавляются к базовому URL):**

| Путь | Метод | Назначение |
|------|--------|------------|
| `/api/v1/summaries` | POST | Саммари по URL или по тексту |
| `/api/v1/summaries/files` | POST | Саммари по загруженному файлу |
| `/api/v1/summaries/fetch` | POST | Получение статьи по URL (контент, заголовок, картинка) |
| `/api/v1/questions` | POST | Вопросы по URL/контексту |
| `/api/v1/questions/files` | POST | Вопросы по файлу |
| `/api/v1/quizzes/generate` | POST | Генерация квиза по тексту |
| `/api/v1/reviews` | POST | Отправка оценки (rate) саммари |
| `/api/v1/feedback` | POST | Запрос функции / обратная связь |
| `/api/v1/translations` | POST | Перевод текста |
| `/api/v1/knowledge-cards` | POST | Извлечение карточек знаний из текста |
| `/api/v1/knowledge-cards/verify` | POST | Проверка ответа по карточке (пока 404/501) |

**Аутентификация:** заголовок `X-API-Key` (значение в `summaryApi.dart`).

---

## 2. Подписки и бандлы (easy4learn / elang)

**Сервис:** `lib/services/bundle_service.dart`

| Окружение | URL | Назначение |
|-----------|-----|------------|
| Prod POST | `https://easy4learn.com/api/v1/users/subscriptions` | Создание подписки |
| Dev POST | `https://dev.elang.app/api/v1/users/subscriptions` | То же (dev) |
| Prod GET | `https://easy4learn.com/api/v1/users/subscriptions?app=com.englishingames.summiShare&bundle=Premium%20Bundle%202` | Информация о бандле |
| Dev GET | `https://dev.elang.app/api/v1/users/subscriptions?app=...&bundle=...` | То же (dev) |

**Аутентификация:** Firebase ID token в заголовке `Authorization: bearer <token>`.

---

## 3. Email (Django API)

| URL | Назначение | Файл |
|-----|------------|------|
| `https://easy4learn.com/django-api/applications/email/` | Отправка email (например, для премиума) | `lib/services/summaryApi.dart` (sendEmail) |

Метод: POST, тело: `{"email": "..."}`.

---

## 4. Firebase

**Файл:** `lib/firebase_options.dart` (генерируется FlutterFire CLI).

| Ресурс | Dev | Prod |
|--------|-----|------|
| Realtime Database (Android) | `https://elang-extension-dev-default-rtdb.europe-west1.firebasedatabase.app` | — |
| Realtime Database (iOS) | — | `https://elang-extension-prod-default-rtdb.europe-west1.firebasedatabase.app` |
| Auth domain (Web) | — | `elang-extension-prod.firebaseapp.com` |
| Storage bucket | `elang-extension-dev.appspot.com` | `elang-extension-prod.appspot.com` |

Аутентификация (логин/логаут, сброс пароля) идёт через Firebase Auth; отдельные URL для Auth в коде не прописаны — используются SDK.

---

## 5. Внешние сервисы и CDN

| URL | Назначение | Файл |
|-----|------------|------|
| `https://huggingface.co/NeuML/kokoro-base-onnx/resolve/main/model.onnx` | Модель TTS Kokoro | `lib/services/tts_service.dart` |
| `https://huggingface.co/NeuML/kokoro-base-onnx/resolve/main/voices.json` | Голоса TTS | `lib/services/tts_service.dart` |
| `https://cdn.jsdelivr.net/` | Базовый URL для загрузки (например, Mermaid) | `lib/screens/mermaid_viewer_screen.dart` |
| `https://mermaid.live` | Открытие диаграммы во внешнем редакторе | `lib/screens/summary_screen/research_tab.dart` |

---

## 6. Ссылки для пользователя (открытие в браузере / магазинах)

### Расширение и магазины

| URL | Где используется |
|-----|-------------------|
| `https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne` | Расширение Summify (Chrome Web Store) — `extension_modal.dart`, `purchase_success_screen.dart` |

### Юридические и поддержка

| URL | Где используется |
|-----|-------------------|
| `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/` | EULA Apple — `support_group.dart`, `terms_restore_privacy.dart` |
| `https://elang.app/privacy` | Политика конфиденциальности — `support_group.dart`, `terms_restore_privacy.dart` |

### О приложении и разработчике

| URL | Где используется |
|-----|-------------------|
| `https://apps.apple.com/ru/developer/english-in-games/id1656052466` | Разработчик в App Store | `about_group.dart` |
| `https://play.google.com/store/apps/dev?id=8797601455128207838&hl=ru&gl=US` | Разработчик в Google Play | `about_group.dart` |
| `https://apps.apple.com/us/app/ai-text-summarizer-summify/id6478384912` | Summify в App Store | `about_group.dart` |

### Реклама других приложений (карусель)

| URL | Приложение |
|-----|------------|
| `https://play.google.com/store/apps/details?id=com.englishingames.englishcards` | English Cards (Android) |
| `https://apps.apple.com/us/app/english-vocab-words-duo-cards/id1658981786` | English Vocab (iOS) |
| `https://play.google.com/store/apps/details?id=com.englishingames.listening` | Listening (Android) |
| `https://apps.apple.com/us/app/english-listening-by-podcast/id6447188725` | Listening (iOS) |
| `https://apps.apple.com/us/app/subtune-listening-podcast/id6464495720` | Subtune (iOS) |
| `https://elang.app/` | Subtune (Android — веб) |
| `https://play.google.com/store/apps/details?id=com.englishingames.easy5` | Easy5 (Android) |
| `https://apps.apple.com/us/app/english-words-new-vocabulary/id1622786750` | English Words (iOS) |
| `https://play.google.com/store/apps/details?id=com.englishingames.easy5verbs` | Easy5 Verbs (Android) |
| `https://apps.apple.com/us/app/1638688704` | Easy5 Verbs (iOS) |

Файл: `lib/widgets/ads_carousel.dart`.

### Дизайн (внутренние ссылки)

| URL | Назначение |
|-----|------------|
| `https://www.figma.com/file/2Rz4IcpAXkHalZP2ivDIIi/Sumishare?type=design&node-id=901-4041&mode=dev` | Figma — дизайн |
| `https://www.figma.com/file/2Rz4IcpAXkHalZP2ivDIIi/Sumishare?type=design&node-id=933-4343&mode=dev` | Figma — дизайн |

Файл: `lib/bloc/mixpanel/mixpanel_bloc.dart`.

---

## 7. Скрипты (вне основного приложения)

| URL | Назначение | Файл |
|-----|------------|------|
| `https://api.lmnotebookpro.com/api/v1/quizzes/generate` | Генерация квиза | `scripts/generate_atomic_habits_quiz.dart` |
| `https://api.lmnotebookpro.com/api/v1/quizzes/generate` | Генерация демо-квиза | `scripts/generate_demo_quiz.dart` |

---

## Сводка: что менять при смене хоста document/LLM API

1. **`lib/services/summaryApi.dart`**
   - `_baseUrlPrimary` — основной хост для всех эндпоинтов `/api/v1/...`.
   - При включении резервов — раскомментировать `_fallbackBaseUrls` и тело `_postWithFallback`.
   - При необходимости — `sendEmailUrl` (отдельный сервис на easy4learn).

2. **`lib/services/bundle_service.dart`**
   - `postUrlProd`, `postUrlDev`, `getSubBundleInfoProd`, `getSubBundleInfoDev` — если подписки переезжают на новый домен.

3. **Скрипты**
   - `scripts/generate_atomic_habits_quiz.dart`, `scripts/generate_demo_quiz.dart` — URL генерации квизов.

4. **Firebase** — только если переносите проект на другой Firebase (тогда перегенерировать `firebase_options.dart` через FlutterFire CLI).

5. **Остальные URL** (магазины, elang.app, Figma, Hugging Face, CDN, mermaid.live) — не относятся к вашему API-серверу; их меняют только при смене маркетинговых/юридических страниц или сервисов.

---

*Документ сгенерирован по коду проекта. При добавлении новых интеграций стоит обновлять этот список.*
