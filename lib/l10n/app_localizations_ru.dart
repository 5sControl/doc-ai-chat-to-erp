// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get common_continue => 'Продолжить';

  @override
  String get common_select => 'Выбрать';

  @override
  String get common_ok => 'Ок';

  @override
  String get common_error => 'Ошибка';

  @override
  String get onboarding_translateSummarizationTo => 'Переводить саммари на';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Прощай, информационная перегрузка!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'В один клик «Поделиться» — и получите саммари';

  @override
  String get onboarding_welcomeTitle => 'Добро пожаловать в Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Персональный AI-саммаризатор';

  @override
  String get settings_profile => 'Профиль';

  @override
  String get settings_general => 'Общие';

  @override
  String get settings_interfaceLanguage => 'Язык интерфейса';

  @override
  String get settings_translationLanguage => 'Язык перевода';

  @override
  String get settings_selectLanguageTitle => 'Выберите язык';

  @override
  String get paywall_beSmartWithYourTime =>
      'Умно распоряжайтесь своим временем!';

  @override
  String get paywall_payWeekly => 'Оплата еженедельно';

  @override
  String get paywall_payAnnually => 'Оплата ежегодно';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Сэкономьте до $amount\\\$';
  }

  @override
  String get paywall_buy => 'КУПИТЬ';

  @override
  String get paywall_andGetOn => 'И ПОЛУЧИТЬ НА';

  @override
  String get paywall_forFree => 'БЕСПЛАТНО!';

  @override
  String get paywall_12Months => '12 месяцев';

  @override
  String get paywall_1Week => '1 неделя';

  @override
  String get paywall_1Month => '1 месяц';

  @override
  String get paywall_1WeekMultiline => '1 \\nнеделя';

  @override
  String get paywall_1MonthMultiline => '1 \\nмесяц';

  @override
  String get paywall_12MonthsMultiline => '12 \\nмесяцев';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Доступ ко всем премиум-функциям!\\nОтмена в любой момент';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/год';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/нед.';
  }

  @override
  String get paywall_termsOfUse => 'Условия использования';

  @override
  String get paywall_restorePurchase => 'Восстановить покупку';

  @override
  String get paywall_privacyPolicy => 'Политика конфиденциальности';

  @override
  String get paywall_unlimitedSummaries => 'Безлимитные саммари';

  @override
  String get paywall_documentResearch => 'Исследование документов';

  @override
  String get paywall_briefAndDeepSummary => 'Краткое и глубокое саммари';

  @override
  String get paywall_translation => 'Перевод';

  @override
  String get paywall_addToChromeForFree => 'Добавить в Chrome бесплатно';

  @override
  String get offer_needMoreSummaries => 'Нужно больше саммари?';

  @override
  String get offer_maximizeYourProductivity => 'Увеличьте продуктивность!';

  @override
  String get offer_outOfSummaries => 'Саммари закончились?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Повышайте продуктивность\\nи эффективность!';

  @override
  String get offer_getMoreInNoTime => 'Получайте больше за меньшее время!';

  @override
  String get offer_15DeepSummariesDaily => '15 глубоких саммари в день';

  @override
  String get offer_goUnlimited => 'Включить безлимит';

  @override
  String get bundle_subscriptionsNotAvailable => 'Подписки недоступны';

  @override
  String get bundle_getForFree => 'ПОЛУЧИТЬ БЕСПЛАТНО';

  @override
  String get bundle_on => 'в';

  @override
  String get bundle_version => 'версии';

  @override
  String get bundle_offer_unlockLimitless => 'Откройте безграничные';

  @override
  String get bundle_offer_possibilities => 'возможности';

  @override
  String get bundle_offer_endlessPossibilities => 'Безграничные возможности';

  @override
  String get bundle_offer_with50Off => 'со скидкой 50%';

  @override
  String get bundle_offer_get4UnlimitedApps =>
      'Получите 4 безлимитных приложения';

  @override
  String get bundle_tabBundle => 'Пакет';

  @override
  String get bundle_tabUnlimited => 'Безлимит';

  @override
  String get purchase_youAreTheBest => 'Вы — лучшие!';

  @override
  String get purchase_get => 'Получите';

  @override
  String get purchase_versionForFree => 'версию бесплатно!';

  @override
  String get purchase_copyLink => 'Скопировать ссылку';

  @override
  String get purchase_collectYourGift => 'Забрать подарок';

  @override
  String get purchase_enterYourEmail => 'Введите email';
}
