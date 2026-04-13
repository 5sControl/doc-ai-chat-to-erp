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
  String get home_deleteSummary_title => 'Удалить документ?';

  @override
  String get home_deleteSummary_message =>
      'Вы уверены, что хотите удалить эту запись? Это действие нельзя отменить.';

  @override
  String get home_deleteSummary_confirm => 'Удалить';

  @override
  String get home_deleteSummary_cancel => 'Отмена';

  @override
  String get onboarding_translateSummarizationTo => 'Переводить саммари на';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Прощай, информационная перегрузка!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'В один клик «Поделиться» — и получите саммари';

  @override
  String get onboarding_welcomeTitle => 'Добро пожаловать в LM Notebook Pro';

  @override
  String get onboarding_welcomeSubtitle => 'Персональный AI-саммаризатор';

  @override
  String get onboarding_moreThanSummary => 'Намного больше, чем саммари';

  @override
  String get onboarding_feature_briefDeep_title => 'Краткое и подробное';

  @override
  String get onboarding_feature_briefDeep_desc =>
      'Короткое или детальное AI-саммари любого контента';

  @override
  String get onboarding_feature_chat_title => 'AI Чат';

  @override
  String get onboarding_feature_chat_desc => 'Задавайте вопросы по документу';

  @override
  String get onboarding_feature_quiz_title => 'Тест';

  @override
  String get onboarding_feature_quiz_desc =>
      'Проверяйте знания с помощью AI-вопросов';

  @override
  String get onboarding_feature_cards_title => 'Карточки знаний';

  @override
  String get onboarding_feature_cards_desc =>
      'Сохраняйте ключевые мысли как флеш-карточки';

  @override
  String get onboarding_feature_input_title => 'Ссылки, файлы и текст';

  @override
  String get onboarding_feature_input_desc =>
      'URL, PDF, документы или вставленный текст';

  @override
  String get settings_profile => 'Профиль';

  @override
  String get settings_title => 'Настройки';

  @override
  String get settings_neverLoseData => 'Никогда не теряйте свои данные!';

  @override
  String get settings_logIn => 'Войти';

  @override
  String get settings_general => 'Общие';

  @override
  String get settings_interfaceLanguage => 'Язык интерфейса';

  @override
  String get settings_translationLanguage => 'Язык перевода';

  @override
  String get settings_selectLanguageTitle => 'Выберите язык';

  @override
  String get settings_group_subscription => 'Подписка и другое';

  @override
  String get settings_group_about => 'О приложении';

  @override
  String get settings_group_support => 'Поддержка';

  @override
  String get settings_group_account => 'Аккаунт';

  @override
  String get settings_group_voice => 'Голос';

  @override
  String get wordTapHint_title => 'Перевод слова';

  @override
  String get wordTapHint_message =>
      'Нажмите на слово, чтобы получить его перевод.';

  @override
  String get wordTapHint_dontShowAgain => 'Больше не показывать';

  @override
  String get wordTapHint_showLater => 'Показать позже';

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
  String get paywall_1WeekMultiline => '1 неделя';

  @override
  String get paywall_1MonthMultiline => '1 месяц';

  @override
  String get paywall_12MonthsMultiline => '12 месяцев';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Доступ ко всем премиум-функциям! Отмена в любой момент';

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
  String get offer_needMoreSummaries => 'Вам нужен успех?';

  @override
  String get offer_maximizeYourProductivity => 'Увеличьте продуктивность!';

  @override
  String get offer_outOfSummaries => 'Саммари закончились?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Повышайте продуктивность и эффективность!';

  @override
  String get offer_getMoreInNoTime => 'Получайте больше за меньшее время!';

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
  String get summary_sourceNotAvailable =>
      'Исходный текст недоступен для этого типа резюме';

  @override
  String get research_chipAskQuestion => 'Задать вопрос';

  @override
  String get research_chipSuggestedQuestions => 'Типовые вопросы';

  @override
  String get research_suggestedQuestionsRequest =>
      'Сгенерируй 5–7 конкретных вопросов, которые стоит задать по этому документу: для уточнения, проверки понимания или обсуждения. Краткий список.';

  @override
  String get research_chipPitfallsLimitations => 'Ограничения и риски';

  @override
  String get research_pitfallsLimitationsRequest =>
      'Перечисли основные ограничения, подводные камни и риски, о которых говорится в документе или которые из него следуют. Кратко, по пунктам.';

  @override
  String get research_chipMermaidDiagram => 'Mermaid-диаграмма';

  @override
  String get research_diagramRequest =>
      'Создай Mermaid-диаграмму по этому документу';

  @override
  String get research_mermaidCopy => 'Копировать';

  @override
  String get research_mermaidOpenLive => 'Открыть в Mermaid Live';

  @override
  String get diagram_share => 'Поделиться';

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
  String get extension_growYourProductivity => 'Быстро и на десктопе';

  @override
  String get extension_copyLink => 'Скопировать ссылку';

  @override
  String get extension_sendLink => 'Отправить ссылку';

  @override
  String get extension_enterYourEmail => 'Введите ваш email';

  @override
  String get extension_openLink => 'Открыть ссылку';

  @override
  String get extension_buyMobileGetDesktop =>
      'Одна покупка — приложение на телефон и на компьютер';

  @override
  String get extension_offerBuy => 'Купи ';

  @override
  String get extension_offerAndGetOn => ' — получи ';

  @override
  String get extension_offerForFree => ' бесплатно!';

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
  String get registration_1FreePerDay => '1 бесплатное в день';

  @override
  String get registration_unlimited => 'безлимитные';

  @override
  String get limit_onePerDay => '1 бесплатное саммари в день';

  @override
  String get limit_resetsTomorrow =>
      'Лимит обновляется в полночь. Завтра снова будет 1 бесплатное саммари.';

  @override
  String get limit_usedTodayTryTomorrow =>
      'Вы уже использовали 1 бесплатное саммари сегодня. Завтра будет ещё одно или оформите подписку.';

  @override
  String get limit_blockedCardOverlay =>
      'Это саммари создано сверх дневного лимита. Откройте по подписке. Завтра будет 1 новое бесплатное саммари.';

  @override
  String get giftCode_menuTitle => 'Ввести подарочный код';

  @override
  String get giftCode_dialogTitle => 'Введите подарочный код';

  @override
  String get giftCode_placeholder => 'Код';

  @override
  String get giftCode_activate => 'Активировать';

  @override
  String giftCode_success(int count) {
    return 'Подарочный код принят. Вам добавлено $count документов.';
  }

  @override
  String get giftCode_error => 'Неверный или уже использованный код.';

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
  String get ttsDownloadDialogTitle => 'Скачивание голосовой модели';

  @override
  String get ttsDownloadDialogBody =>
      'Пожалуйста, не закрывайте приложение во время скачивания голосовых ресурсов.';

  @override
  String get ttsModelReadyTitle => 'Голосовая модель готова';

  @override
  String get ttsModelReadyMessage =>
      'Голосовая модель успешно скачана. Вы можете выбрать голос в Настройках.';

  @override
  String get knowledgeCards_regenerate => 'Создать заново';

  @override
  String get knowledgeCards_regenerateTitle => 'Создать карточки заново?';

  @override
  String get knowledgeCards_regenerateMessage =>
      'Текущие карточки будут удалены, будут сгенерированы новые. Продолжить?';

  @override
  String get knowledgeCards_cancel => 'Отмена';

  @override
  String knowledgeCards_voiceAnswerTitle(Object term) {
    return 'Как вы понимаете термин «$term»?';
  }

  @override
  String get knowledgeCards_voiceAnswerQuestion => 'Как вы понимаете термин?';

  @override
  String get knowledgeCards_voiceAnswerTask => 'Объясните своими словами';

  @override
  String get knowledgeCards_voiceAnswerSend => 'Отправить';

  @override
  String get knowledgeCards_voiceAnswerStubMessage =>
      'Проверка верности ответа появится в программе в скором времени.';

  @override
  String get knowledgeCards_voiceAnswerError =>
      'Не удалось проверить ответ. Проверьте подключение и попробуйте снова.';

  @override
  String get knowledgeCards_tapMicToSpeak =>
      'Нажмите на микрофон, чтобы говорить';

  @override
  String get knowledgeCards_listening => 'Идёт запись...';

  @override
  String get copy_paste_required_title => 'Не удалось загрузить страницу';

  @override
  String get copy_paste_required_message =>
      'Это не ошибка. Сервер не может загрузить этот материал автоматически. Скопируйте текст со страницы и вставьте его в поле ввода в приложении.';
}
