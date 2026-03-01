// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get common_continue => 'Kontynuuj';

  @override
  String get common_select => 'Wybierz';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Błąd';

  @override
  String get onboarding_translateSummarizationTo => 'Tłumacz podsumowania na';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Żegnaj, przeciążenie informacjami!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Jedno kliknięcie „Udostępnij”, aby uzyskać podsumowanie';

  @override
  String get onboarding_welcomeTitle => 'Witamy w Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Osobisty podsumowujący AI';

  @override
  String get settings_profile => 'Profil';

  @override
  String get settings_title => 'Ustawienia';

  @override
  String get settings_general => 'Ogólne';

  @override
  String get settings_interfaceLanguage => 'Język interfejsu';

  @override
  String get settings_translationLanguage => 'Język tłumaczenia';

  @override
  String get settings_selectLanguageTitle => 'Wybierz język';

  @override
  String get settings_group_subscription => 'Subskrypcja i więcej';

  @override
  String get settings_group_about => 'O aplikacji';

  @override
  String get settings_group_support => 'Pomoc';

  @override
  String get settings_group_account => 'Konto';

  @override
  String get settings_group_voice => 'Głos';

  @override
  String get wordTapHint_title => 'Tłumaczenie słowa';

  @override
  String get wordTapHint_message =>
      'Dotknij słowa, aby uzyskać jego tłumaczenie.';

  @override
  String get wordTapHint_dontShowAgain => 'Nie pokazuj ponownie';

  @override
  String get wordTapHint_showLater => 'Pokaż później';

  @override
  String get paywall_beSmartWithYourTime => 'Oszczędzaj swój czas!';

  @override
  String get paywall_payWeekly => 'Płatność tygodniowa';

  @override
  String get paywall_payAnnually => 'Płatność roczna';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Oszczędź do $amount\\\$';
  }

  @override
  String get paywall_buy => 'KUP';

  @override
  String get paywall_andGetOn => 'I OTRZYMAJ NA';

  @override
  String get paywall_forFree => 'ZA DARMO!';

  @override
  String get paywall_12Months => '12 miesięcy';

  @override
  String get paywall_1Week => '1 tydzień';

  @override
  String get paywall_1Month => '1 miesiąc';

  @override
  String get paywall_1WeekMultiline => '1 tydzień';

  @override
  String get paywall_1MonthMultiline => '1 miesiąc';

  @override
  String get paywall_12MonthsMultiline => '12 miesięcy';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Dostęp do wszystkich funkcji premium! Anuluj w dowolnym momencie';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/rok';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/tydz.';
  }

  @override
  String get paywall_termsOfUse => 'Warunki użytkowania';

  @override
  String get paywall_restorePurchase => 'Przywróć zakup';

  @override
  String get paywall_privacyPolicy => 'Polityka prywatności';

  @override
  String get paywall_unlimitedSummaries => 'Nielimitowane podsumowania';

  @override
  String get paywall_documentResearch => 'Analiza dokumentów';

  @override
  String get paywall_briefAndDeepSummary =>
      'Krótkie i szczegółowe podsumowanie';

  @override
  String get paywall_translation => 'Tłumaczenie';

  @override
  String get paywall_addToChromeForFree => 'Dodaj do Chrome ZA DARMO';

  @override
  String get offer_needMoreSummaries => 'Potrzebujesz sukcesu?';

  @override
  String get offer_maximizeYourProductivity => 'Zwiększ swoją produktywność!';

  @override
  String get offer_outOfSummaries => 'Brak podsumowań?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Zwiększ produktywność i efektywność!';

  @override
  String get offer_getMoreInNoTime => 'Zyskaj więcej w mgnieniu oka!';

  @override
  String get offer_goUnlimited => 'Włącz bez limitu';

  @override
  String get bundle_subscriptionsNotAvailable => 'Subskrypcje niedostępne';

  @override
  String get bundle_getForFree => 'ODBIERZ ZA DARMO';

  @override
  String get bundle_on => 'w';

  @override
  String get bundle_version => 'wersji';

  @override
  String get bundle_offer_unlockLimitless => 'Odblokuj nieograniczone';

  @override
  String get bundle_offer_possibilities => 'możliwości';

  @override
  String get bundle_offer_endlessPossibilities => 'Nieskończone możliwości';

  @override
  String get bundle_offer_with50Off => 'z 50% zniżką';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Zdobądź 4 aplikacje bez limitu';

  @override
  String get bundle_tabBundle => 'Pakiet';

  @override
  String get bundle_tabUnlimited => 'Bez limitu';

  @override
  String get purchase_youAreTheBest => 'Jesteś najlepszy!';

  @override
  String get purchase_get => 'Zdobądź';

  @override
  String get purchase_versionForFree => 'wersję za darmo!';

  @override
  String get purchase_copyLink => 'Kopiuj link';

  @override
  String get purchase_collectYourGift => 'Odbierz prezent';

  @override
  String get purchase_enterYourEmail => 'Wpisz e-mail';

  @override
  String get summary_couldNotOpenURL => 'Nie można otworzyć URL';

  @override
  String get summary_couldNotOpenFile => 'Nie można otworzyć pliku';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'Oryginalny plik nie jest już dostępny';

  @override
  String get summary_filePathNotFound => 'Nie znaleziono ścieżki do pliku';

  @override
  String get summary_originalTextNotAvailable => 'Oryginalny tekst niedostępny';

  @override
  String get summary_breakThroughTheLimits => 'Przekrocz limity';

  @override
  String get summary_sourceNotAvailable =>
      'Tekst źródłowy nie jest dostępny dla tego typu podsumowania';

  @override
  String get research_chipAskQuestion => 'Ask a question';

  @override
  String get research_chipSuggestedQuestions => 'Sugerowane pytania';

  @override
  String get research_suggestedQuestionsRequest =>
      'Wygeneruj 5–7 konkretnych pytań wartych zadania o tym dokumencie: do wyjaśnienia, sprawdzenia zrozumienia lub dyskusji. Tylko krótka lista.';

  @override
  String get research_chipPitfallsLimitations => 'Pułapki i ograniczenia';

  @override
  String get research_pitfallsLimitationsRequest =>
      'Wypisz główne ograniczenia, pułapki i ryzyka wymienione lub wynikające z tego dokumentu. Zwięźle, w punktach.';

  @override
  String get research_chipMermaidDiagram => 'Mermaid diagram';

  @override
  String get research_diagramRequest =>
      'Create a Mermaid diagram for this document';

  @override
  String get research_mermaidCopy => 'Copy';

  @override
  String get research_mermaidOpenLive => 'Open in Mermaid Live';

  @override
  String get diagram_share => 'Udostępnij';

  @override
  String get quiz_failedToGenerate => 'Nie udało się wygenerować quizu';

  @override
  String get quiz_retry => 'Ponów';

  @override
  String get quiz_knowledgeQuiz => 'Quiz wiedzy';

  @override
  String get quiz_testYourUnderstanding =>
      'Sprawdź swoje zrozumienie tego dokumentu';

  @override
  String get quiz_questions => 'Pytania';

  @override
  String get quiz_estimatedTime => 'Szacowany czas';

  @override
  String get quiz_minutes => 'min';

  @override
  String get quiz_startQuiz => 'Rozpocznij quiz';

  @override
  String get quiz_explanation => 'Wyjaśnienie';

  @override
  String get quiz_previous => 'Poprzednie';

  @override
  String get quiz_viewResults => 'Zobacz wyniki';

  @override
  String get quiz_nextQuestion => 'Następne pytanie';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Pytanie $current z $total';
  }

  @override
  String get quiz_overview => 'Przegląd';

  @override
  String get quiz_stepByStep => 'Krok po kroku';

  @override
  String get quiz_excellent => 'Doskonale! 🎉';

  @override
  String get quiz_goodJob => 'Dobra robota! 👍';

  @override
  String get quiz_notBad => 'Nieźle! Ucz się dalej 📚';

  @override
  String get quiz_keepPracticing => 'Ćwicz dalej! 💪';

  @override
  String get quiz_correct => 'Poprawnie';

  @override
  String get quiz_incorrect => 'Niepoprawnie';

  @override
  String get quiz_total => 'Razem';

  @override
  String get quiz_retakeQuiz => 'Powtórz quiz';

  @override
  String get quiz_reviewAnswers => 'Sprawdź odpowiedzi';

  @override
  String quiz_question(Object number) {
    return 'Pytanie $number';
  }

  @override
  String get savedCards_title => 'Zapisane karty';

  @override
  String get savedCards_removeBookmarkTitle => 'Usunąć zakładkę?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Ta karta zostanie usunięta z zakładek.';

  @override
  String get savedCards_cancel => 'Anuluj';

  @override
  String get savedCards_remove => 'Usuń';

  @override
  String get savedCards_cardRemoved => 'Karta usunięta z zakładek';

  @override
  String get savedCards_sourceNotFound => 'Nie znaleziono źródłowego dokumentu';

  @override
  String get savedCards_clearAll => 'Wyczyść wszystko';

  @override
  String get savedCards_searchHint => 'Szukaj zapisanych kart...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count karta';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count kart';
  }

  @override
  String get savedCards_clearFilters => 'Wyczyść filtry';

  @override
  String get savedCards_noCardsYet => 'Brak zapisanych kart';

  @override
  String get savedCards_saveCardsToAccess =>
      'Zapisuj ciekawe karty, aby uzyskać do nich później dostęp';

  @override
  String get savedCards_noCardsFound => 'Nie znaleziono kart';

  @override
  String get savedCards_tryAdjustingFilters => 'Spróbuj dostosować filtry';

  @override
  String get savedCards_clearAllTitle => 'Wyczyścić wszystkie zapisane karty?';

  @override
  String get savedCards_clearAllMessage =>
      'Spowoduje to usunięcie wszystkich zapisanych kart. Tej operacji nie można cofnąć.';

  @override
  String get savedCards_allCleared =>
      'Wszystkie zapisane karty zostały usunięte';

  @override
  String get home_search => 'Szukaj';

  @override
  String get info_productivityInfo => 'Informacje o produktywności';

  @override
  String get info_words => 'Słowa';

  @override
  String get info_time => 'Czas, ';

  @override
  String get info_timeMin => '(min)';

  @override
  String get info_saved => 'Zaoszczędzono, ';

  @override
  String get info_original => 'Oryginał';

  @override
  String get info_brief => 'Krótkie';

  @override
  String get info_deep => 'Szczegółowe';

  @override
  String get extension_growYourProductivity => 'Szybko też na desktopie';

  @override
  String get extension_copyLink => 'Kopiuj link';

  @override
  String get extension_sendLink => 'Wyślij link';

  @override
  String get extension_enterYourEmail => 'Wpisz swój e-mail';

  @override
  String get extension_openLink => 'Otwórz link';

  @override
  String get extension_buyMobileGetDesktop =>
      'Jedna zakup — korzystaj na telefonie i komputerze';

  @override
  String get extension_offerBuy => 'Kup ';

  @override
  String get extension_offerAndGetOn => ' i korzystaj na ';

  @override
  String get extension_offerForFree => ' za darmo!';

  @override
  String get auth_skip => 'Pomiń';

  @override
  String get auth_hello => 'Witaj!';

  @override
  String get auth_fillInToGetStarted => 'Wypełnij, aby rozpocząć';

  @override
  String get auth_emailAddress => 'Adres e-mail';

  @override
  String get auth_password => 'Hasło';

  @override
  String get auth_forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get auth_loginIn => 'Zaloguj się';

  @override
  String get auth_orLoginWith => 'Lub zaloguj się za pomocą';

  @override
  String get auth_dontHaveAccount => 'Nie masz konta? ';

  @override
  String get auth_registerNow => 'Zarejestruj się teraz';

  @override
  String get auth_passwordCannotBeEmpty => 'Hasło nie może być puste';

  @override
  String get auth_passwordMustBe6Chars =>
      'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get registration_skip => 'Pomiń';

  @override
  String get registration_registerAndGet => 'Zarejestruj się i otrzymaj';

  @override
  String get registration_2Free => '2 darmowe ';

  @override
  String get registration_1FreePerDay => '1 free per day';

  @override
  String get registration_unlimited => 'nieograniczone';

  @override
  String get limit_onePerDay => '1 free summary per day';

  @override
  String get limit_resetsTomorrow =>
      'Limit resets at midnight. You get 1 more free summary tomorrow.';

  @override
  String get limit_usedTodayTryTomorrow =>
      'You\'ve used your 1 free summary today. Come back tomorrow for another one, or go unlimited.';

  @override
  String get limit_blockedCardOverlay =>
      'This summary was created over your daily limit. Unlock with Premium. Tomorrow you get 1 new free summary.';

  @override
  String get giftCode_menuTitle => 'Wprowadź kod podarunkowy';

  @override
  String get giftCode_dialogTitle => 'Wprowadź kod podarunkowy';

  @override
  String get giftCode_placeholder => 'Kod';

  @override
  String get giftCode_activate => 'Aktywuj';

  @override
  String giftCode_success(int count) {
    return 'Kod podarunkowy zaakceptowany. Otrzymałeś $count dokumentów.';
  }

  @override
  String get giftCode_error => 'Nieprawidłowy lub już użyty kod.';

  @override
  String get registration_summarizations => 'podsumowania';

  @override
  String get registration_name => 'Imię';

  @override
  String get registration_emailAddress => 'Adres e-mail';

  @override
  String get registration_password => 'Hasło';

  @override
  String get registration_confirmPassword => 'Potwierdź hasło';

  @override
  String get registration_register => 'Zarejestruj się';

  @override
  String get registration_orLoginWith => 'Lub zaloguj się za pomocą';

  @override
  String get registration_alreadyHaveAccount => 'Masz już konto? ';

  @override
  String get registration_loginNow => 'Zaloguj się teraz';

  @override
  String get registration_passwordMismatch => 'Hasła nie pasują';

  @override
  String get request_secureSum => 'Bezpieczne podsumowanie';

  @override
  String get request_readMyBook => 'Przeczytaj moją książkę';

  @override
  String get request_speechToText => 'Funkcja mowy na tekst';

  @override
  String get request_textToSpeech => 'Funkcja tekstu na mowę';

  @override
  String get request_addLanguage => 'Dodaj język';

  @override
  String get request_orWriteMessage => 'Lub napisz do nas wiadomość';

  @override
  String get request_name => 'Imię';

  @override
  String get request_enterYourName => 'Wpisz swoje imię';

  @override
  String get request_email => 'E-mail';

  @override
  String get request_enterYourEmail => 'Wpisz swój e-mail';

  @override
  String get request_message => 'Wiadomość';

  @override
  String get request_enterYourRequest => 'Wpisz swoją prośbę';

  @override
  String get request_submit => 'Wyślij';

  @override
  String get request_selectLanguage => 'Wybierz język';

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

  @override
  String get knowledgeCards_regenerate => 'Wygeneruj ponownie';

  @override
  String get knowledgeCards_regenerateTitle => 'Wygenerować karty ponownie?';

  @override
  String get knowledgeCards_regenerateMessage =>
      'Obecne karty zostaną usunięte i wygenerowane na nowo. Kontynuować?';

  @override
  String get knowledgeCards_cancel => 'Anuluj';

  @override
  String knowledgeCards_voiceAnswerTitle(Object term) {
    return 'Jak rozumiesz termin \"$term\"?';
  }

  @override
  String get knowledgeCards_voiceAnswerQuestion => 'Jak rozumiesz termin?';

  @override
  String get knowledgeCards_voiceAnswerTask => 'Wyjaśnij własnymi słowami';

  @override
  String get knowledgeCards_voiceAnswerSend => 'Wyślij';

  @override
  String get knowledgeCards_voiceAnswerStubMessage =>
      'Weryfikacja Twojej odpowiedzi będzie wkrótce dostępna w aplikacji.';

  @override
  String get knowledgeCards_voiceAnswerError =>
      'Nie udało się zweryfikować odpowiedzi. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get knowledgeCards_tapMicToSpeak => 'Dotknij mikrofonu, aby mówić';

  @override
  String get knowledgeCards_listening => 'Słucham...';
}
