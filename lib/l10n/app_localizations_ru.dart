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

  @override
  String get summary_couldNotOpenURL => 'Не удалось открыть URL';

  @override
  String get summary_couldNotOpenFile => 'Не удалось открыть файл';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'Оригинальный файл больше не доступен';

  @override
  String get summary_filePathNotFound => 'Путь к файлу не найден';

  @override
  String get summary_originalTextNotAvailable => 'Исходный текст недоступен';

  @override
  String get summary_breakThroughTheLimits => 'Преодолейте ограничения';

  @override
  String get summary_sourceTab => 'Источник';

  @override
  String get summary_sourceNotAvailable =>
      'Исходный текст недоступен для этого типа резюме';

  @override
  String get quiz_failedToGenerate => 'Не удалось создать квиз';

  @override
  String get quiz_retry => 'Повторить';

  @override
  String get quiz_knowledgeQuiz => 'Тест знаний';

  @override
  String get quiz_testYourUnderstanding =>
      'Проверьте ваше понимание этого документа';

  @override
  String get quiz_questions => 'Вопросы';

  @override
  String get quiz_estimatedTime => 'Примерное время';

  @override
  String get quiz_minutes => 'мин';

  @override
  String get quiz_startQuiz => 'Начать квиз';

  @override
  String get quiz_explanation => 'Объяснение';

  @override
  String get quiz_previous => 'Назад';

  @override
  String get quiz_viewResults => 'Посмотреть результаты';

  @override
  String get quiz_nextQuestion => 'Следующий вопрос';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get quiz_overview => 'Обзор';

  @override
  String get quiz_stepByStep => 'Пошагово';

  @override
  String get quiz_excellent => 'Отлично! 🎉';

  @override
  String get quiz_goodJob => 'Хорошая работа! 👍';

  @override
  String get quiz_notBad => 'Неплохо! Продолжайте учиться 📚';

  @override
  String get quiz_keepPracticing => 'Продолжайте практиковаться! 💪';

  @override
  String get quiz_correct => 'Верно';

  @override
  String get quiz_incorrect => 'Неверно';

  @override
  String get quiz_total => 'Всего';

  @override
  String get quiz_retakeQuiz => 'Пройти квиз снова';

  @override
  String get quiz_reviewAnswers => 'Проверить ответы';

  @override
  String quiz_question(Object number) {
    return 'Вопрос $number';
  }

  @override
  String get savedCards_title => 'Сохраненные карточки';

  @override
  String get savedCards_removeBookmarkTitle => 'Удалить закладку?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Эта карточка будет удалена из ваших закладок.';

  @override
  String get savedCards_cancel => 'Отмена';

  @override
  String get savedCards_remove => 'Удалить';

  @override
  String get savedCards_cardRemoved => 'Карточка удалена из закладок';

  @override
  String get savedCards_sourceNotFound => 'Исходный документ не найден';

  @override
  String get savedCards_clearAll => 'Очистить все';

  @override
  String get savedCards_searchHint => 'Поиск сохраненных карточек...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count карточка';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count карточек';
  }

  @override
  String get savedCards_clearFilters => 'Очистить фильтры';

  @override
  String get savedCards_noCardsYet => 'Пока нет сохраненных карточек';

  @override
  String get savedCards_saveCardsToAccess =>
      'Сохраняйте интересные карточки для быстрого доступа';

  @override
  String get savedCards_noCardsFound => 'Карточки не найдены';

  @override
  String get savedCards_tryAdjustingFilters => 'Попробуйте изменить фильтры';

  @override
  String get savedCards_clearAllTitle => 'Очистить все сохраненные карточки?';

  @override
  String get savedCards_clearAllMessage =>
      'Это удалит все ваши сохраненные карточки. Это действие нельзя отменить.';

  @override
  String get savedCards_allCleared => 'Все сохраненные карточки удалены';

  @override
  String get home_search => 'Поиск';

  @override
  String get info_productivityInfo => 'Информация о продуктивности';

  @override
  String get info_words => 'Слова';

  @override
  String get info_time => 'Время, ';

  @override
  String get info_timeMin => '(мин)';

  @override
  String get info_saved => 'Сэкономлено, ';

  @override
  String get info_original => 'Оригинал';

  @override
  String get info_brief => 'Краткое';

  @override
  String get info_deep => 'Глубокое';

  @override
  String get extension_growYourProductivity => 'ПОВЫШАЙТЕ ПРОДУКТИВНОСТЬ';

  @override
  String get extension_copyLink => 'Скопировать ссылку';

  @override
  String get extension_sendLink => 'Отправить ссылку';

  @override
  String get extension_enterYourEmail => 'Введите ваш email';

  @override
  String get auth_skip => 'Пропустить';

  @override
  String get auth_hello => 'Привет!';

  @override
  String get auth_fillInToGetStarted => 'Заполните, чтобы начать';

  @override
  String get auth_emailAddress => 'Адрес электронной почты';

  @override
  String get auth_password => 'Пароль';

  @override
  String get auth_forgotPassword => 'Забыли пароль?';

  @override
  String get auth_loginIn => 'Войти';

  @override
  String get auth_orLoginWith => 'Или войдите с помощью';

  @override
  String get auth_dontHaveAccount => 'Нет аккаунта? ';

  @override
  String get auth_registerNow => 'Зарегистрируйтесь';

  @override
  String get auth_passwordCannotBeEmpty => 'Пароль не может быть пустым';

  @override
  String get auth_passwordMustBe6Chars =>
      'Пароль должен содержать не менее 6 символов';

  @override
  String get registration_skip => 'Пропустить';

  @override
  String get registration_registerAndGet => 'Зарегистрируйтесь и получите';

  @override
  String get registration_2Free => '2 бесплатные ';

  @override
  String get registration_unlimited => 'безлимитные';

  @override
  String get registration_summarizations => 'саммари';

  @override
  String get registration_name => 'Имя';

  @override
  String get registration_emailAddress => 'Адрес электронной почты';

  @override
  String get registration_password => 'Пароль';

  @override
  String get registration_confirmPassword => 'Подтвердите пароль';

  @override
  String get registration_register => 'Зарегистрироваться';

  @override
  String get registration_orLoginWith => 'Или войдите с помощью';

  @override
  String get registration_alreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get registration_loginNow => 'Войдите сейчас';

  @override
  String get registration_passwordMismatch => 'Пароли не совпадают';

  @override
  String get request_secureSum => 'Безопасная саммаризация';

  @override
  String get request_readMyBook => 'Прочитать мою книгу';

  @override
  String get request_speechToText => 'Функция речь-в-текст';

  @override
  String get request_textToSpeech => 'Функция текст-в-речь';

  @override
  String get request_addLanguage => 'Добавить язык';

  @override
  String get request_orWriteMessage => 'Или напишите нам сообщение';

  @override
  String get request_name => 'Имя';

  @override
  String get request_enterYourName => 'Введите ваше имя';

  @override
  String get request_email => 'Email';

  @override
  String get request_enterYourEmail => 'Введите ваш email';

  @override
  String get request_message => 'Сообщение';

  @override
  String get request_enterYourRequest => 'Введите ваш запрос';

  @override
  String get request_submit => 'Отправить';

  @override
  String get request_selectLanguage => 'Выберите язык';

  @override
  String get ttsDownloadDialogTitle => 'Downloading voice model';

  @override
  String get ttsDownloadDialogBody =>
      'Please keep the app open while we download the voice resources.';

  @override
  String get ttsModelReadyTitle => 'Voice model ready';

  @override
  String get ttsModelReadyMessage =>
      'Voice model downloaded successfully. You can choose a voice in Settings.';
}
