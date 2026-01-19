# Текстовая схема переходов между экранами подписок

## Общая структура

```
┌─────────────────────────────────────────────────────────────────┐
│                    ТОЧКИ ВХОДА                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ Settings │  │   Home   │  │ Summary  │  │Onboarding│     │
│  │  Screen  │  │  Screen  │  │  Screen  │  │  Screen  │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │              │             │            │
│       │             │              │             │            │
│       └─────────────┴──────────────┴─────────────┘            │
│                    │                                           │
│              NextScreenEvent()                                 │
│                    │                                           │
└────────────────────┼───────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                  ОСНОВНЫЕ ЭКРАНЫ ПОДПИСОК                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              BundleScreen                                │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ TabController (length: 2)                        │  │  │
│  │  │                                                  │  │  │
│  │  │  ┌──────────────┐      ┌──────────────┐        │  │  │
│  │  │  │  Tab 0:      │      │  Tab 1:      │        │  │  │
│  │  │  │  Bundle      │      │  Unlimited   │        │  │  │
│  │  │  │              │      │              │        │  │  │
│  │  │  │ BundleScreen1│      │SubscriptionScreen│    │  │  │
│  │  │  │              │      │Limit          │        │  │  │
│  │  │  │ Monthly: $7.99│     │(OffersBloc)   │        │  │  │
│  │  │  │ Annual: $49.99│     │               │        │  │  │
│  │  │  └──────────────┘      └──────────────┘        │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │        SubscriptionScreenLimit                            │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ OffersBloc: screenIndex (0-5)                   │  │  │
│  │  │                                                  │  │  │
│  │  │  Index 0: "Need more summaries?"                 │  │  │
│  │  │  Index 1: "Maximize your productivity!"          │  │  │
│  │  │  Index 2: "Out of Summaries?"                    │  │  │
│  │  │  Index 3: "Need more summaries?" + Features      │  │  │
│  │  │  Index 4: → SubscriptionScreen                   │  │  │
│  │  │  Index 5: "Out of Summaries?" + Features        │  │  │
│  │  │                                                  │  │  │
│  │  │  NextScreenEvent() → (index + 1) % 6            │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │        SubscriptionScreen                                  │  │
│  │  (Показывается при screenIndex == 4)                      │  │
│  │                                                            │  │
│  │  Weekly: $0.99                                            │  │
│  │  Monthly: $4.99                                           │  │
│  │  Yearly: $34.99                                            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                     │
                     │ Go Premium / Go Unlimited
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                  ПРОЦЕСС ПОКУПКИ                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. MakePurchase Event                                         │
│     │                                                           │
│     ├─→ SubscriptionsBloc                                      │
│     │                                                           │
│     ├─→ Purchases.purchasePackage()                            │
│     │                                                           │
│     ├─→ Проверка entitlements:                                 │
│     │   - "Summify premium access" (Premium)                  │
│     │   - activeSubscriptions (Bundle)                         │
│     │                                                           │
│     ├─→ Bundle API (для Bundle подписок):                      │
│     │   - createSubscription(subData)                          │
│     │                                                           │
│     └─→ SubscriptionStatus.subscribed                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                     │
                     │ Success
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              PurchaseSuccessScreen                              │
│              (Modal Bottom Sheet)                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  - Показывается поверх текущего экрана                         │
│  - Позволяет ввести email для получения Chrome Extension       │
│  - После закрытия возвращает на предыдущий экран               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Детальная схема OffersBloc

```
OffersBloc State Machine:
─────────────────────────

Initial State: screenIndex = 0

┌─────────┐
│ Index 0 │ ──NextScreenEvent()──> ┌─────────┐
│ Offer 0 │                         │ Index 1 │
│         │                         │ Offer 1 │
└─────────┘                         └────┬────┘
                                         │
                                         │ NextScreenEvent()
                                         ▼
                                    ┌─────────┐
                                    │ Index 2 │
                                    │ Offer 2 │
                                    └────┬────┘
                                         │
                                         │ NextScreenEvent()
                                         ▼
                                    ┌─────────┐
                                    │ Index 3 │
                                    │ Offer 3 │
                                    └────┬────┘
                                         │
                                         │ NextScreenEvent()
                                         ▼
                                    ┌─────────┐
                                    │ Index 4 │ ──> SubscriptionScreen
                                    │         │     (полноценный экран)
                                    └────┬────┘
                                         │
                                         │ NextScreenEvent()
                                         ▼
                                    ┌─────────┐
                                    │ Index 5 │
                                    │ Offer 5 │
                                    └────┬────┘
                                         │
                                         │ NextScreenEvent()
                                         └───┐
                                             │
                                             ▼
                                    ┌─────────┐
                                    │ Index 0 │ (цикл)
                                    │ Offer 0 │
                                    └─────────┘

Формула: nextIndex = (currentIndex + 1) % 6
```

## Схема BundleScreen

```
BundleScreen Structure:
───────────────────────

BundleScreen (StatefulWidget)
│
├─ TabController
│  ├─ length: 2
│  ├─ initialIndex: fromOnboarding ? 1 : 0
│  └─ Listener: обновляет состояние при переключении
│
├─ Tab 0: Bundle
│  └─ BundleScreen1
│     ├─ Title: "Unlock Limitless Possibilities" (рандомно)
│     ├─ Body: SpeechScribe + Summify
│     ├─ Body1: "GET FOR FREE" (Chrome версии)
│     └─ PricesBloc
│        ├─ Monthly Bundle: $7.99
│        └─ Annual Bundle: $49.99
│
└─ Tab 1: Unlimited
   └─ SubscriptionScreenLimit
      └─ OffersBloc управляет содержимым
         └─ screenIndex определяет отображаемый контент
```

## Схема SubscriptionScreenLimit

```
SubscriptionScreenLimit Logic:
──────────────────────────────

SubscriptionScreenLimit
│
├─ OffersBloc Builder
│  └─ screenIndex (0-5)
│
├─ Conditional Rendering:
│  │
│  ├─ if screenIndex == 4:
│  │  └─ → SubscriptionScreen (полноценный экран)
│  │
│  └─ else:
│     ├─ Human Image (зависит от screenIndex)
│     ├─ Title (зависит от screenIndex)
│     ├─ SubTitle (зависит от screenIndex)
│     │
│     ├─ if screenIndex < 3:
│     │  ├─ Text1: "15 Deep Summaries Daily"
│     │  └─ PricesBloc: Weekly/Monthly/Yearly
│     │
│     └─ if screenIndex >= 3:
│        ├─ Features List:
│        │  ├─ Unlimited Summaries
│        │  ├─ Document Research
│        │  ├─ Brief and Deep Summary
│        │  ├─ Translation
│        │  └─ Add to Chrome for FREE
│        └─ PricesBloc: Weekly/Monthly/Yearly
│
└─ SubscribeButton
   └─ MakePurchase Event
```

## Последовательность покупки

```
Purchase Flow Sequence:
───────────────────────

1. User Action
   │
   └─→ Нажимает "Go Premium" / "Go Unlimited"
       │
       ▼

2. UI Layer
   │
   └─→ SubscribeButton.onPressGoPremium()
       │
       ├─→ context.read<SubscriptionsBloc>()
       │   .add(MakePurchase(package: selectedPackage))
       │
       └─→ context.read<MixpanelBloc>()
           .add(ActivateSubscription(plan: packageType))
       │
       ▼

3. SubscriptionsBloc
   │
   └─→ on<MakePurchase>
       │
       ├─→ Purchases.purchasePackage(package)
       │
       ├─→ CustomerInfo получен
       │
       ├─→ Проверка entitlements:
       │   │
       │   ├─ if "Summify premium access"?.isActive:
       │   │  └─→ Premium subscription
       │   │     └─→ emit(SubscriptionStatus.subscribed)
       │   │
       │   └─ else:
       │      ├─→ Bundle subscription
       │      ├─→ startEndDates(customerInfo)
       │      ├─→ bundleService.createSubscription(subData)
       │      └─→ emit(SubscriptionStatus.subscribed)
       │
       └─→ showMaterialModalBottomSheet
           └─→ PurchaseSuccessScreen
       │
       ▼

4. PurchaseSuccessScreen
   │
   ├─→ Modal Bottom Sheet отображается
   │
   ├─→ User может ввести email (опционально)
   │
   ├─→ onPressGift() → sendEmail(email)
   │
   └─→ Navigator.pushNamed('/') → возврат на главный экран
```

## Навигационные пути

```
Navigation Paths:
─────────────────

Path 1: Settings → Subscription
────────────────────────────────
Settings Screen
  │
  └─ onPressSubscription()
     │
     ├─→ OffersBloc.add(NextScreenEvent())
     │
     └─→ Navigator.push(SubscriptionScreenLimit)
         │
         └─→ SubscriptionScreenLimit
             └─→ OffersBloc cycle (screenIndex 0-5)


Path 2: Settings → Bundle
──────────────────────────
Settings Screen
  │
  └─ onPressSubscription1()
     │
     ├─→ OffersBloc.add(NextScreenEvent())
     │
     └─→ Navigator.push(BundleScreen)
         │
         └─→ BundleScreen
             ├─→ Tab 0: Bundle
             └─→ Tab 1: Unlimited → SubscriptionScreenLimit


Path 3: Home → Bundle
─────────────────────
Home Screen
  │
  └─ Premium Banner (onTap)
     │
     ├─→ OffersBloc.add(NextScreenEvent())
     │
     └─→ Navigator.push(BundleScreen)
         │
         └─→ BundleScreen (Tab 0 по умолчанию)


Path 4: Summary → Subscription
───────────────────────────────
Summary Screen
  │
  └─ Premium Blur Container (onTap)
     │
     ├─→ OffersBloc.add(NextScreenEvent())
     │
     └─→ Navigator.push(SubscriptionScreenLimit)
         │
         └─→ SubscriptionScreenLimit
             └─→ OffersBloc cycle


Path 5: Onboarding → Bundle
───────────────────────────
Onboarding Screen
  │
  └─→ Navigator.push(BundleScreen)
      │
      └─→ BundleScreen
          └─→ Tab 1 (initialIndex = 1)
              └─→ SubscriptionScreenLimit
```

## Ключевые компоненты

```
Key Components:
───────────────

1. OffersBloc
   ├─ State: OffersState(screenIndex: 0-5)
   ├─ Event: NextScreenEvent()
   └─ Logic: nextIndex = (currentIndex + 1) % 6

2. SubscriptionsBloc
   ├─ State: SubscriptionsState
   │   ├─ availableProducts: Offerings?
   │   └─ subscriptionStatus: SubscriptionStatus
   ├─ Events:
   │   ├─ InitSubscriptions
   │   ├─ MakePurchase
   │   ├─ GetSubscriptionStatus
   │   └─ RestoreSubscriptions
   └─ Logic: Управление подписками через RevenueCat

3. BundleScreen
   ├─ TabController (2 таба)
   ├─ Tab 0: BundleScreen1
   └─ Tab 1: SubscriptionScreenLimit

4. SubscriptionScreenLimit
   ├─ OffersBloc Builder
   ├─ Conditional Rendering по screenIndex
   └─ PricesBloc + SubscribeButton

5. PurchaseSuccessScreen
   ├─ Modal Bottom Sheet
   ├─ Email input (опционально)
   └─ sendEmail API call
```


