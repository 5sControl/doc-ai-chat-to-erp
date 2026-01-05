# Инфраструктура подписок, продуктов и лимитов Summify

## Обзор

Документ описывает полную инфраструктуру платежей, подписок, продуктов, лимитов и ограничений в приложении Summify.

## Схемы переходов между экранами

Для визуализации логики переходов между экранами подписок созданы следующие схемы:

1. **[SVG диаграмма](./subscription_flow_diagram.svg)** - Визуальная схема в формате SVG с цветовым кодированием и легендой
2. **[Mermaid диаграммы](./subscription_flow_mermaid.md)** - Интерактивные диаграммы в формате Mermaid (поддерживается GitHub, GitLab и многими редакторами)
3. **[Текстовая схема](./subscription_flow_text.md)** - Детальная текстовая схема с ASCII-артом для быстрого понимания структуры

---

## 1. Продукты подписки

### 1.1. Группа подписок "Premium" (Subscription Group: Premium)

#### 1.1.1. SummifyPremiumWeekly
- **Product ID**: `SummifyPremiumWeekly`
- **Тип**: RecurringSubscription
- **Период**: 1 неделя (P1W)
- **Цена**: $0.99
- **Reference Name**: `1w_sb_nbn_pr`
- **Group Number**: 1
- **Family Shareable**: false
- **Описание**: "Get more summaries for text, video and files"
- **Display Name**: "Summify: AI Summarizer Weekly"
- **Introductory Offer**: $0.99 (paymentMode: none)

#### 1.1.2. SummifyPremiumMonth
- **Product ID**: `SummifyPremiumMonth`
- **Тип**: RecurringSubscription
- **Период**: 1 месяц (P1M)
- **Цена**: $4.99
- **Reference Name**: `1m_sb_nbn_pr`
- **Group Number**: 2
- **Family Shareable**: false
- **Описание**: "Get more summaries for text, video and files"
- **Display Name**: "Summify: AI Summarizer Monthly"
- **Introductory Offer**: нет
- **Code Offers**:
  - "One month free" - 1 месяц бесплатно (для новых, существующих и истекших подписок)

#### 1.1.3. SummifyPremiumYear
- **Product ID**: `SummifyPremiumYear`
- **Тип**: RecurringSubscription
- **Период**: 1 год (P1Y)
- **Цена**: $34.99
- **Reference Name**: `1y_sb_nbn_pr`
- **Group Number**: 3
- **Family Shareable**: false
- **Описание**: "Get more summaries for text, video and files"
- **Display Name**: "Summify: AI Summarizer Annual"
- **Introductory Offer**: нет
- **Code Offers**:
  - "one year free" - 1 год бесплатно (для новых, существующих и истекших подписок)

### 1.2. Группа подписок "Premium_bundle_2" (Bundle подписки)

#### 1.2.1. SummifyMonthlyBundleSubscription
- **Product ID**: `SummifyMonthlyBundleSubscription`
- **Тип**: RecurringSubscription
- **Период**: 1 месяц (P1M)
- **Цена**: $7.99
- **Reference Name**: `1m_sb_bn_pr`
- **Group Number**: 1
- **Family Shareable**: false
- **Описание**: "Break free from limits!"
- **Display Name**: "Monthly Limitless Bundle"
- **Introductory Offer**: нет

#### 1.2.2. SummifyAnnualBundleSubscription
- **Product ID**: `SummifyAnnualBundleSubscription`
- **Тип**: RecurringSubscription
- **Период**: 1 год (P1Y)
- **Цена**: $49.99
- **Reference Name**: `1y_sb_bn_pr`
- **Group Number**: 3
- **Family Shareable**: false
- **Описание**: "Break free from limits!"
- **Display Name**: "Annual Limitless Bundle"
- **Introductory Offer**: нет

---

## 2. Лимиты и ограничения

### 2.1. Бесплатный тариф (Free Tier)

#### Лимиты:
- **Количество бесплатных summary**: **2 summary**
- После достижения лимита контент блокируется (`isBlocked: true`)
- Лимит применяется ко всем типам summary:
  - Summary из URL
  - Summary из текста
  - Summary из файлов

#### Ограничения:
- Нет доступа к премиум функциям
- Ограниченное количество summary

### 2.2. Премиум тариф (Premium Subscription)

#### Лимиты:
- **Количество summary**: **Unlimited (безлимитно)**
- В UI упоминается "15 Deep Summaries Daily" (возможно, маркетинговое сообщение или устаревшая информация)
- Все summary разблокированы (`isBlocked: false`)

#### Доступные функции:
1. **Unlimited Summaries** - безлимитное количество summary
2. **Document Research** - исследование документов
3. **Brief and Deep Summary** - краткие и глубокие summary
4. **Translation** - перевод
5. **Add to Chrome for FREE** - бесплатное расширение для Chrome

### 2.3. Bundle подписка

#### Включенные продукты:
- **Summify** - полный доступ ко всем функциям
- **SpeechScribe** - приложение для транскрипции речи
- **Chrome расширения** - бесплатные версии обоих приложений для Chrome

#### Лимиты:
- Те же, что и у премиум подписки (Unlimited)

---

## 3. Entitlements (Права доступа)

### 3.1. "Summify premium access"
- Используется для проверки активной премиум подписки
- Проверяется через `customerInfo.entitlements.all["Summify premium access"]?.isActive`
- Применяется для обычных подписок (Weekly, Monthly, Yearly)

### 3.2. Bundle подписки
- Проверяются через API: `https://easy4learn.com/api/v1/users/subscriptions`
- Параметры запроса:
  - `app`: `com.englishingames.summiShare`
  - `bundle`: `Premium Bundle 2`
- Возвращает:
  - `productStoreId` - ID продукта в магазине
  - `duration` - длительность подписки
  - `isFinished` - статус завершения подписки

---

## 4. Логика проверки подписки

### 4.1. Определение статуса подписки

```dart
SubscriptionStatus {
  subscribed,    // Пользователь имеет активную подписку
  unsubscribed   // Пользователь не имеет подписки
}
```

### 4.2. Условия активации подписки

Подписка считается активной, если выполняется одно из условий:
1. `customerInfo.activeSubscriptions.isNotEmpty` - есть активные подписки в RevenueCat
2. `bundleInfo() != null && user?.uid != null && !isFinished` - есть активная bundle подписка через API

### 4.3. Блокировка контента

Контент блокируется (`isBlocked: true`), если:
- `freeSummaries >= 2` И
- `subscriptionStatus == SubscriptionStatus.unsubscribed`

---

## 5. Типы summary

### 5.1. По источнику (SummaryOrigin)
- **URL** - summary из веб-страницы
- **Text** - summary из введенного текста
- **File** - summary из загруженного файла

### 5.2. По типу (SummaryType)
- **Short** - краткое summary
- **Long** - глубокое summary

### 5.3. Статусы (SummaryStatus)
- **complete** - summary готово
- **error** - ошибка при создании summary
- **loading** - summary в процессе создания

---

## 6. Ценообразование и скидки

### 6.1. Отображение цен
- Цены отображаются с зачеркнутой старой ценой (цена × 2)
- Пример: если цена $4.99, показывается зачеркнутая цена $9.98

### 6.2. Скидки
- Все подписки показываются со скидкой 50% (визуально)
- Bundle подписки позиционируются как "50% Off"

### 6.3. Промо-коды
- **"One month free"** - для месячной подписки
- **"one year free"** - для годовой подписки
- Доступны для: новых, существующих и истекших подписок
- Stackable: true (можно комбинировать)

---

## 7. Интеграция с платежными системами

### 7.1. RevenueCat (Purchases SDK)
- **Android API Key**: `goog_ugQdxFfTdHeYrhnJzuBXhYIUtQM`
- **iOS API Key**: `appl_CzcmziXEyjKtEOYgYuQMLCTGvtf`
- Используется для управления подписками и проверки статуса

### 7.2. Firebase Authentication
- User ID используется для синхронизации подписок
- Токен используется для API запросов bundle подписок

### 7.3. Backend API
- **Production**: `https://easy4learn.com/api/v1/users/subscriptions`
- **Development**: `https://dev.elang.app/api/v1/users/subscriptions`
- Используется для управления bundle подписками

---

## 8. UI экраны подписок

### 8.1. SubscriptionScreenLimit
- Основной экран для продажи подписок
- Показывает 3 варианта: Weekly, Monthly, Yearly
- Отображает функции премиум
- Триггеры: Settings, Home, Summary

### 8.2. BundleScreen
- Экран для продажи bundle подписок
- Показывает 2 варианта: Monthly Bundle, Annual Bundle
- Подчеркивает получение Chrome расширений бесплатно

### 8.3. Offer Screens
- 6 различных экранов предложений (screenIndex: 0-5)
- Разные заголовки и изображения
- Адаптивный контент в зависимости от индекса

---

## 9. Счетчик бесплатных summary

### 9.1. Механизм подсчета
- Счетчик `freeSummaries` увеличивается при каждом успешном создании summary
- Сбрасывается при активации подписки (неявно, через разблокировку)
- Хранится в `SummariesState`

### 9.2. Условия инкремента
Счетчик увеличивается (`IncrementFreeSummaries`) при:
- Успешном создании summary из URL
- Успешном создании summary из текста
- Успешном создании summary из файла

---

## 10. Схема работы подписок

```
┌─────────────────────────────────────────────────────────┐
│                    Пользователь                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Проверка подписки     │
        │  (GetSubscriptionStatus)│
        └────────┬───────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌──────────────┐  ┌──────────────┐
│ RevenueCat   │  │ Bundle API   │
│ (activeSubs) │  │ (bundleInfo) │
└──────┬───────┘  └──────┬───────┘
       │                 │
       └────────┬────────┘
                │
                ▼
    ┌───────────────────────┐
    │ SubscriptionStatus    │
    │ - subscribed          │
    │ - unsubscribed        │
    └───────────┬───────────┘
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
┌──────────────┐  ┌──────────────┐
│ Premium      │  │ Free         │
│ - Unlimited │  │ - 2 summary  │
│ - All features│ │ - Blocked    │
└──────────────┘  └──────────────┘
```

---

## 11. Ключевые файлы кода

### 11.1. Подписки
- `lib/bloc/subscriptions/subscriptions_bloc.dart` - логика управления подписками
- `lib/bloc/subscriptions/subscriptions_state.dart` - состояние подписок
- `lib/helpers/purchases.dart` - интеграция с RevenueCat

### 11.2. Лимиты
- `lib/bloc/summaries/summaries_bloc.dart` - логика summary и лимитов
- `lib/bloc/summaries/summaries_state.dart` - состояние summary

### 11.3. UI
- `lib/screens/subscribtions_screen/subscriptions_screen_limit.dart` - экран подписок
- `lib/screens/bundle_screen/bundle_offer_screen.dart` - экран bundle подписок

### 11.4. Конфигурация
- `ios/StoreKitConfig.storekit` - конфигурация продуктов iOS
- `ios/Config.storekit` - дополнительная конфигурация iOS

---

## 12. Важные замечания

1. **Лимит бесплатных summary**: Реально ограничение составляет **2 summary**, а не 15, как может показаться из UI сообщений.

2. **Bundle подписки**: Управляются через отдельный API, не через RevenueCat entitlements.

3. **Цены**: Фактические цены могут отличаться в зависимости от региона и валюты.

4. **Промо-коды**: Доступны через StoreKit, но требуют настройки на стороне App Store Connect.

5. **Chrome расширения**: Предоставляются бесплатно при покупке любой подписки (особенно подчеркивается в bundle).

---

## 13. Таблица сравнения тарифов

| Функция | Free | Premium | Bundle |
|---------|------|---------|--------|
| Количество summary | 2 | Unlimited | Unlimited |
| Document Research | ❌ | ✅ | ✅ |
| Brief Summary | ✅ | ✅ | ✅ |
| Deep Summary | ✅ | ✅ | ✅ |
| Translation | ❌ | ✅ | ✅ |
| Chrome Extension | ❌ | ✅ | ✅ |
| SpeechScribe | ❌ | ❌ | ✅ |
| SpeechScribe Chrome | ❌ | ❌ | ✅ |
| Цена (месяц) | $0 | $4.99 | $7.99 |
| Цена (год) | $0 | $34.99 | $49.99 |

---

*Документ создан на основе анализа кода приложения Summify*
*Последнее обновление: 2024*

