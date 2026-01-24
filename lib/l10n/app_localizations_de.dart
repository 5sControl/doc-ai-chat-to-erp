// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get common_continue => 'Weiter';

  @override
  String get common_select => 'Auswählen';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Fehler';

  @override
  String get onboarding_translateSummarizationTo =>
      'Zusammenfassungen übersetzen nach';

  @override
  String get onboarding_goodbyeInfoOverload => 'Tschüss, Informationsflut!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Mit einem Klick auf „Teilen“ zur Zusammenfassung';

  @override
  String get onboarding_welcomeTitle => 'Willkommen bei Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Persönlicher KI-Zusammenfasser';

  @override
  String get settings_profile => 'Profil';

  @override
  String get settings_general => 'Allgemein';

  @override
  String get settings_interfaceLanguage => 'Sprache der Oberfläche';

  @override
  String get settings_translationLanguage => 'Übersetzungssprache';

  @override
  String get settings_selectLanguageTitle => 'Sprache auswählen';

  @override
  String get paywall_beSmartWithYourTime => 'Nutze deine Zeit klug!';

  @override
  String get paywall_payWeekly => 'Wöchentlich zahlen';

  @override
  String get paywall_payAnnually => 'Jährlich zahlen';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Spare bis zu $amount\\\$';
  }

  @override
  String get paywall_buy => 'KAUFEN';

  @override
  String get paywall_andGetOn => 'UND ERHALTE AUF';

  @override
  String get paywall_forFree => 'KOSTENLOS!';

  @override
  String get paywall_12Months => '12 Monate';

  @override
  String get paywall_1Week => '1 Woche';

  @override
  String get paywall_1Month => '1 Monat';

  @override
  String get paywall_1WeekMultiline => '1 \\nWoche';

  @override
  String get paywall_1MonthMultiline => '1 \\nMonat';

  @override
  String get paywall_12MonthsMultiline => '12 \\nMonate';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Zugriff auf alle Premium-Funktionen!\\nJederzeit kündbar';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/Jahr';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/Woche';
  }

  @override
  String get paywall_termsOfUse => 'Nutzungsbedingungen';

  @override
  String get paywall_restorePurchase => 'Kauf wiederherstellen';

  @override
  String get paywall_privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get paywall_unlimitedSummaries => 'Unbegrenzte Zusammenfassungen';

  @override
  String get paywall_documentResearch => 'Dokumentenrecherche';

  @override
  String get paywall_briefAndDeepSummary =>
      'Kurze und ausführliche Zusammenfassung';

  @override
  String get paywall_translation => 'Übersetzung';

  @override
  String get paywall_addToChromeForFree => 'Zu Chrome hinzufügen – KOSTENLOS';

  @override
  String get offer_needMoreSummaries => 'Mehr Zusammenfassungen nötig?';

  @override
  String get offer_maximizeYourProductivity => 'Maximiere deine Produktivität!';

  @override
  String get offer_outOfSummaries => 'Keine Zusammenfassungen mehr?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Maximiere deine Produktivität\\nund Effizienz!';

  @override
  String get offer_getMoreInNoTime => 'Erreiche mehr in kürzester Zeit!';

  @override
  String get offer_15DeepSummariesDaily =>
      '15 ausführliche Zusammenfassungen täglich';

  @override
  String get offer_goUnlimited => 'Unbegrenzt freischalten';

  @override
  String get bundle_subscriptionsNotAvailable => 'Abonnements nicht verfügbar';

  @override
  String get bundle_getForFree => 'KOSTENLOS ERHALTEN';

  @override
  String get bundle_on => 'auf';

  @override
  String get bundle_version => 'Version';

  @override
  String get bundle_offer_unlockLimitless => 'Entfessle grenzenlose';

  @override
  String get bundle_offer_possibilities => 'Möglichkeiten';

  @override
  String get bundle_offer_endlessPossibilities => 'Endlose Möglichkeiten';

  @override
  String get bundle_offer_with50Off => 'mit 50% Rabatt';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Hol dir 4 unbegrenzte Apps';

  @override
  String get bundle_tabBundle => 'Bundle';

  @override
  String get bundle_tabUnlimited => 'Unbegrenzt';

  @override
  String get purchase_youAreTheBest => 'Du bist der Beste!';

  @override
  String get purchase_get => 'Hol dir';

  @override
  String get purchase_versionForFree => 'Version kostenlos!';

  @override
  String get purchase_copyLink => 'Link kopieren';

  @override
  String get purchase_collectYourGift => 'Geschenk abholen';

  @override
  String get purchase_enterYourEmail => 'E-Mail eingeben';

  @override
  String get summary_couldNotOpenURL => 'URL konnte nicht geöffnet werden';

  @override
  String get summary_couldNotOpenFile => 'Datei konnte nicht geöffnet werden';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'Originaldatei ist nicht mehr verfügbar';

  @override
  String get summary_filePathNotFound => 'Dateipfad nicht gefunden';

  @override
  String get summary_originalTextNotAvailable => 'Originaltext nicht verfügbar';

  @override
  String get summary_breakThroughTheLimits => 'Überwinde die Grenzen';

  @override
  String get quiz_failedToGenerate => 'Quiz konnte nicht generiert werden';

  @override
  String get quiz_retry => 'Wiederholen';

  @override
  String get quiz_knowledgeQuiz => 'Wissensquiz';

  @override
  String get quiz_testYourUnderstanding =>
      'Teste dein Verständnis dieses Dokuments';

  @override
  String get quiz_questions => 'Fragen';

  @override
  String get quiz_estimatedTime => 'Geschätzte Zeit';

  @override
  String get quiz_minutes => 'Min';

  @override
  String get quiz_startQuiz => 'Quiz starten';

  @override
  String get quiz_explanation => 'Erklärung';

  @override
  String get quiz_previous => 'Zurück';

  @override
  String get quiz_viewResults => 'Ergebnisse anzeigen';

  @override
  String get quiz_nextQuestion => 'Nächste Frage';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Frage $current von $total';
  }

  @override
  String get quiz_overview => 'Übersicht';

  @override
  String get quiz_stepByStep => 'Schritt für Schritt';

  @override
  String get quiz_excellent => 'Ausgezeichnet! 🎉';

  @override
  String get quiz_goodJob => 'Gut gemacht! 👍';

  @override
  String get quiz_notBad => 'Nicht schlecht! Lerne weiter 📚';

  @override
  String get quiz_keepPracticing => 'Übe weiter! 💪';

  @override
  String get quiz_correct => 'Richtig';

  @override
  String get quiz_incorrect => 'Falsch';

  @override
  String get quiz_total => 'Gesamt';

  @override
  String get quiz_retakeQuiz => 'Quiz wiederholen';

  @override
  String get quiz_reviewAnswers => 'Antworten überprüfen';

  @override
  String quiz_question(Object number) {
    return 'Frage $number';
  }

  @override
  String get savedCards_title => 'Gespeicherte Karten';

  @override
  String get savedCards_removeBookmarkTitle => 'Lesezeichen entfernen?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Diese Karte wird aus deinen Lesezeichen entfernt.';

  @override
  String get savedCards_cancel => 'Abbrechen';

  @override
  String get savedCards_remove => 'Entfernen';

  @override
  String get savedCards_cardRemoved => 'Karte aus Lesezeichen entfernt';

  @override
  String get savedCards_sourceNotFound => 'Quelldokument nicht gefunden';

  @override
  String get savedCards_clearAll => 'Alle löschen';

  @override
  String get savedCards_searchHint => 'Gespeicherte Karten durchsuchen...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count Karte';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count Karten';
  }

  @override
  String get savedCards_clearFilters => 'Filter löschen';

  @override
  String get savedCards_noCardsYet => 'Noch keine gespeicherten Karten';

  @override
  String get savedCards_saveCardsToAccess =>
      'Speichere interessante Karten für späteren Zugriff';

  @override
  String get savedCards_noCardsFound => 'Keine Karten gefunden';

  @override
  String get savedCards_tryAdjustingFilters =>
      'Versuche, die Filter anzupassen';

  @override
  String get savedCards_clearAllTitle => 'Alle gespeicherten Karten löschen?';

  @override
  String get savedCards_clearAllMessage =>
      'Dies entfernt alle deine gespeicherten Karten. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get savedCards_allCleared => 'Alle gespeicherten Karten gelöscht';

  @override
  String get home_search => 'Suche';

  @override
  String get info_productivityInfo => 'Produktivitätsinfo';

  @override
  String get info_words => 'Wörter';

  @override
  String get info_time => 'Zeit, ';

  @override
  String get info_timeMin => '(Min)';

  @override
  String get info_saved => 'Gespart, ';

  @override
  String get info_original => 'Original';

  @override
  String get info_brief => 'Kurz';

  @override
  String get info_deep => 'Ausführlich';

  @override
  String get extension_growYourProductivity => 'STEIGERE DEINE PRODUKTIVITÄT';

  @override
  String get extension_copyLink => 'Link kopieren';

  @override
  String get extension_sendLink => 'Link senden';

  @override
  String get extension_enterYourEmail => 'E-Mail eingeben';

  @override
  String get auth_skip => 'Überspringen';

  @override
  String get auth_hello => 'Hallo!';

  @override
  String get auth_fillInToGetStarted => 'Fülle aus, um zu beginnen';

  @override
  String get auth_emailAddress => 'E-Mail-Adresse';

  @override
  String get auth_password => 'Passwort';

  @override
  String get auth_forgotPassword => 'Passwort vergessen?';

  @override
  String get auth_loginIn => 'Anmelden';

  @override
  String get auth_orLoginWith => 'Oder anmelden mit';

  @override
  String get auth_dontHaveAccount => 'Noch kein Konto? ';

  @override
  String get auth_registerNow => 'Jetzt registrieren';

  @override
  String get auth_passwordCannotBeEmpty => 'Passwort darf nicht leer sein';

  @override
  String get auth_passwordMustBe6Chars =>
      'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get registration_skip => 'Überspringen';

  @override
  String get registration_registerAndGet => 'Registriere dich und erhalte';

  @override
  String get registration_2Free => '2 kostenlose ';

  @override
  String get registration_unlimited => 'unbegrenzte';

  @override
  String get registration_summarizations => 'Zusammenfassungen';

  @override
  String get registration_name => 'Name';

  @override
  String get registration_emailAddress => 'E-Mail-Adresse';

  @override
  String get registration_password => 'Passwort';

  @override
  String get registration_confirmPassword => 'Passwort bestätigen';

  @override
  String get registration_register => 'Registrieren';

  @override
  String get registration_orLoginWith => 'Oder anmelden mit';

  @override
  String get registration_alreadyHaveAccount => 'Hast du bereits ein Konto? ';

  @override
  String get registration_loginNow => 'Jetzt anmelden';

  @override
  String get registration_passwordMismatch =>
      'Passwörter stimmen nicht überein';

  @override
  String get request_secureSum => 'Sichere Zusammenfassung';

  @override
  String get request_readMyBook => 'Mein Buch lesen';

  @override
  String get request_speechToText => 'Sprache-zu-Text-Funktion';

  @override
  String get request_textToSpeech => 'Text-zu-Sprache-Funktion';

  @override
  String get request_addLanguage => 'Sprache hinzufügen';

  @override
  String get request_orWriteMessage => 'Oder schreibe uns eine Nachricht';

  @override
  String get request_name => 'Name';

  @override
  String get request_enterYourName => 'Gib deinen Namen ein';

  @override
  String get request_email => 'E-Mail';

  @override
  String get request_enterYourEmail => 'Gib deine E-Mail ein';

  @override
  String get request_message => 'Nachricht';

  @override
  String get request_enterYourRequest => 'Gib deine Anfrage ein';

  @override
  String get request_submit => 'Senden';

  @override
  String get request_selectLanguage => 'Sprache auswählen';
}
