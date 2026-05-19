# Flutter 3.44 — чеклист миграции Summify

Дата: 2026-05-19  
`flutter analyze`: **403 issues** (в основном info/warning, не блокеры сборки)

## Сделано

| Файл | Проблема | Действие |
|------|----------|----------|
| `lib/screens/summary_screen/share_copy_button.dart` | `WillPopScope` deprecated | → `PopScope(canPop: false)` |
| `lib/themes/light_theme.dart` | `ThemeData.indicatorColor` deprecated | Удалено (TabBar уже с `indicator: BoxDecoration`) |
| `lib/screens/settings_screen/tts_settings_section.dart` | `DropdownButtonFormField.value` deprecated | → `DropdownButton` + `InputDecorator` |

---

## P1 — Flutter / платформа (рекомендуется)

| # | Тема | Файлы / область | Действие |
|---|------|-----------------|----------|
| 1 | **Android built-in Kotlin** (3.44) | `android/app/build.gradle`, `android/settings.gradle`, `android/build.gradle` | Миграция с `kotlin-android` / KGP на built-in Kotlin ([гайд](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin)) до AGP 9 |
| 2 | **UISceneDelegate** (3.38) | `ios/Runner/` | Добавить Scene lifecycle по [гайду](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate) |
| 3 | **MaterialState → WidgetState** | ~15 файлов (см. analyze) | `dart fix --apply` или массовая замена `MaterialStateProperty*` → `WidgetStateProperty*` |
| 4 | **Color.withOpacity → withValues** | `summary_tile.dart`, подписки, settings… | По мере касания файлов |
| 5 | **SvgPicture `color` → `colorFilter`** | `auth_screen.dart`, `registration_screen.dart`, `bundle_offer_screen.dart` | Заменить deprecated `color:` |
| 6 | **toastification** | `show_error_toast.dart`, `show_success_toast.dart` | `closeButtonShowType` → `closeButton` |
| 7 | **Switch.activeColor** | `notifications_switch.dart` | → `activeThumbColor` |

---

## P2 — Качество кода (не связано с 3.44)

| Категория | Примеры | Кол-во (порядок) |
|-----------|---------|------------------|
| `avoid_print` | `main.dart`, blocs, `purchases.dart` | много |
| `unused_import` / `unused_element` | `auth_screen.dart`, `subscriptions_bloc.dart` | ~20 warnings |
| `unnecessary_non_null_assertion` | `auth_screen.dart`, bundle screens | ~40 |
| `file_names` | `lib/bloc/library/books/*.dart` | 16 info |
| `invalid_use_of_visible_for_testing_member` | `quiz_bloc.dart:301` | 1 warning |

---

## P3 — Визуальная регрессия (тесты, без правок кода)

- Material 3 tokens (3.27 / 3.41) — кастомные `light_theme` / `dark_theme`
- Android Predictive Back / page transitions (3.38)
- `ListTile` + цветной `Material` внутри — debug warning (3.44): `summary_tile.dart`

---

## Не требуется для Summify

`RawMenuAnchor`, `onReorder`, `cacheExtent`, custom `IconData`, `ReorderableListView`, новый `Radio` API, `OverlayPortal`, v1 Android embedding.

---

## Команды

```bash
flutter analyze
dart fix --dry-run
dart fix --apply
```
