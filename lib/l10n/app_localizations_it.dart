// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get common_continue => 'Continua';

  @override
  String get common_select => 'Seleziona';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Errore';

  @override
  String get onboarding_translateSummarizationTo => 'Traduci i riassunti in';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Addio al sovraccarico di informazioni!';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Un clic su \"Condividi\" per ottenere il riassunto';

  @override
  String get onboarding_welcomeTitle => 'Benvenuto su Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Riassuntore IA personale';

  @override
  String get settings_profile => 'Profilo';

  @override
  String get settings_general => 'Generale';

  @override
  String get settings_interfaceLanguage => 'Lingua dell\'interfaccia';

  @override
  String get settings_translationLanguage => 'Lingua di traduzione';

  @override
  String get settings_selectLanguageTitle => 'Seleziona la lingua';

  @override
  String get wordTapHint_title => 'Traduzione parole';

  @override
  String get wordTapHint_message =>
      'Tocca due volte una parola per ottenere la traduzione.';

  @override
  String get wordTapHint_dontShowAgain => 'Non mostrare più';

  @override
  String get wordTapHint_showLater => 'Mostra più tardi';

  @override
  String get paywall_beSmartWithYourTime => 'Usa il tuo tempo al meglio!';

  @override
  String get paywall_payWeekly => 'Paga settimanalmente';

  @override
  String get paywall_payAnnually => 'Paga annualmente';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Risparmia fino a $amount\\\$';
  }

  @override
  String get paywall_buy => 'ACQUISTA';

  @override
  String get paywall_andGetOn => 'E OTTIENI SU';

  @override
  String get paywall_forFree => 'GRATIS!';

  @override
  String get paywall_12Months => '12 mesi';

  @override
  String get paywall_1Week => '1 settimana';

  @override
  String get paywall_1Month => '1 mese';

  @override
  String get paywall_1WeekMultiline => '1 settimana';

  @override
  String get paywall_1MonthMultiline => '1 mese';

  @override
  String get paywall_12MonthsMultiline => '12 mesi';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Accedi a tutte le funzionalità premium! Annulla quando vuoi';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/anno';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/settimana';
  }

  @override
  String get paywall_termsOfUse => 'Termini di utilizzo';

  @override
  String get paywall_restorePurchase => 'Ripristina acquisto';

  @override
  String get paywall_privacyPolicy => 'Informativa sulla privacy';

  @override
  String get paywall_unlimitedSummaries => 'Riassunti illimitati';

  @override
  String get paywall_documentResearch => 'Ricerca documenti';

  @override
  String get paywall_briefAndDeepSummary => 'Riassunto breve e approfondito';

  @override
  String get paywall_translation => 'Traduzione';

  @override
  String get paywall_addToChromeForFree => 'Aggiungi a Chrome GRATIS';

  @override
  String get offer_needMoreSummaries => 'Avete bisogno di successo?';

  @override
  String get offer_maximizeYourProductivity =>
      'Massimizza la tua produttività!';

  @override
  String get offer_outOfSummaries => 'Riassunti esauriti?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Massimizza produttività ed efficienza!';

  @override
  String get offer_getMoreInNoTime => 'Ottieni di più in poco tempo!';

  @override
  String get offer_goUnlimited => 'Attiva illimitato';

  @override
  String get bundle_subscriptionsNotAvailable => 'Abbonamenti non disponibili';

  @override
  String get bundle_getForFree => 'OTTIENI GRATIS';

  @override
  String get bundle_on => 'su';

  @override
  String get bundle_version => 'Versione';

  @override
  String get bundle_offer_unlockLimitless => 'Sblocca infinite';

  @override
  String get bundle_offer_possibilities => 'possibilità';

  @override
  String get bundle_offer_endlessPossibilities => 'Possibilità infinite';

  @override
  String get bundle_offer_with50Off => 'con il 50% di sconto';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Ottieni 4 app illimitate';

  @override
  String get bundle_tabBundle => 'Pacchetto';

  @override
  String get bundle_tabUnlimited => 'Illimitato';

  @override
  String get purchase_youAreTheBest => 'Sei il migliore!';

  @override
  String get purchase_get => 'Ottieni';

  @override
  String get purchase_versionForFree => 'la versione gratis!';

  @override
  String get purchase_copyLink => 'Copia link';

  @override
  String get purchase_collectYourGift => 'Ritira il tuo regalo';

  @override
  String get purchase_enterYourEmail => 'Inserisci la tua email';

  @override
  String get summary_couldNotOpenURL => 'Impossibile aprire l\'URL';

  @override
  String get summary_couldNotOpenFile => 'Impossibile aprire il file';

  @override
  String get summary_originalFileNoLongerAvailable =>
      'Il file originale non è più disponibile';

  @override
  String get summary_filePathNotFound => 'Percorso del file non trovato';

  @override
  String get summary_originalTextNotAvailable =>
      'Testo originale non disponibile';

  @override
  String get summary_breakThroughTheLimits => 'Supera i limiti';

  @override
  String get summary_sourceNotAvailable =>
      'Il testo sorgente non è disponibile per questo tipo di riepilogo';

  @override
  String get quiz_failedToGenerate => 'Impossibile generare il quiz';

  @override
  String get quiz_retry => 'Riprova';

  @override
  String get quiz_knowledgeQuiz => 'Quiz di conoscenza';

  @override
  String get quiz_testYourUnderstanding =>
      'Metti alla prova la tua comprensione di questo documento';

  @override
  String get quiz_questions => 'Domande';

  @override
  String get quiz_estimatedTime => 'Tempo stimato';

  @override
  String get quiz_minutes => 'min';

  @override
  String get quiz_startQuiz => 'Inizia quiz';

  @override
  String get quiz_explanation => 'Spiegazione';

  @override
  String get quiz_previous => 'Precedente';

  @override
  String get quiz_viewResults => 'Visualizza risultati';

  @override
  String get quiz_nextQuestion => 'Prossima domanda';

  @override
  String quiz_questionNofTotal(Object current, Object total) {
    return 'Domanda $current di $total';
  }

  @override
  String get quiz_overview => 'Panoramica';

  @override
  String get quiz_stepByStep => 'Passo dopo passo';

  @override
  String get quiz_excellent => 'Eccellente! 🎉';

  @override
  String get quiz_goodJob => 'Buon lavoro! 👍';

  @override
  String get quiz_notBad => 'Niente male! Continua a imparare 📚';

  @override
  String get quiz_keepPracticing => 'Continua a esercitarti! 💪';

  @override
  String get quiz_correct => 'Corretto';

  @override
  String get quiz_incorrect => 'Errato';

  @override
  String get quiz_total => 'Totale';

  @override
  String get quiz_retakeQuiz => 'Ripeti quiz';

  @override
  String get quiz_reviewAnswers => 'Rivedi risposte';

  @override
  String quiz_question(Object number) {
    return 'Domanda $number';
  }

  @override
  String get savedCards_title => 'Carte salvate';

  @override
  String get savedCards_removeBookmarkTitle => 'Rimuovere segnalibro?';

  @override
  String get savedCards_removeBookmarkMessage =>
      'Questa carta verrà rimossa dai tuoi segnalibri.';

  @override
  String get savedCards_cancel => 'Annulla';

  @override
  String get savedCards_remove => 'Rimuovi';

  @override
  String get savedCards_cardRemoved => 'Carta rimossa dai segnalibri';

  @override
  String get savedCards_sourceNotFound => 'Documento sorgente non trovato';

  @override
  String get savedCards_clearAll => 'Cancella tutto';

  @override
  String get savedCards_searchHint => 'Cerca carte salvate...';

  @override
  String savedCards_cardCount(Object count) {
    return '$count carta';
  }

  @override
  String savedCards_cardsCount(Object count) {
    return '$count carte';
  }

  @override
  String get savedCards_clearFilters => 'Cancella filtri';

  @override
  String get savedCards_noCardsYet => 'Ancora nessuna carta salvata';

  @override
  String get savedCards_saveCardsToAccess =>
      'Salva carte interessanti per accedervi più tardi';

  @override
  String get savedCards_noCardsFound => 'Nessuna carta trovata';

  @override
  String get savedCards_tryAdjustingFilters => 'Prova ad aggiustare i filtri';

  @override
  String get savedCards_clearAllTitle => 'Cancellare tutte le carte salvate?';

  @override
  String get savedCards_clearAllMessage =>
      'Questo rimuoverà tutte le tue carte salvate. Questa azione non può essere annullata.';

  @override
  String get savedCards_allCleared =>
      'Tutte le carte salvate sono state cancellate';

  @override
  String get home_search => 'Cerca';

  @override
  String get info_productivityInfo => 'Info produttività';

  @override
  String get info_words => 'Parole';

  @override
  String get info_time => 'Tempo, ';

  @override
  String get info_timeMin => '(min)';

  @override
  String get info_saved => 'Risparmiato, ';

  @override
  String get info_original => 'Originale';

  @override
  String get info_brief => 'Breve';

  @override
  String get info_deep => 'Approfondito';

  @override
  String get extension_growYourProductivity => 'AUMENTA LA TUA PRODUTTIVITÀ';

  @override
  String get extension_copyLink => 'Copia link';

  @override
  String get extension_sendLink => 'Invia link';

  @override
  String get extension_enterYourEmail => 'Inserisci la tua email';

  @override
  String get auth_skip => 'Salta';

  @override
  String get auth_hello => 'Ciao!';

  @override
  String get auth_fillInToGetStarted => 'Compila per iniziare';

  @override
  String get auth_emailAddress => 'Indirizzo email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_forgotPassword => 'Password dimenticata?';

  @override
  String get auth_loginIn => 'Accedi';

  @override
  String get auth_orLoginWith => 'Oppure accedi con';

  @override
  String get auth_dontHaveAccount => 'Non hai un account? ';

  @override
  String get auth_registerNow => 'Registrati ora';

  @override
  String get auth_passwordCannotBeEmpty => 'La password non può essere vuota';

  @override
  String get auth_passwordMustBe6Chars =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get registration_skip => 'Salta';

  @override
  String get registration_registerAndGet => 'Registrati e ottieni';

  @override
  String get registration_2Free => '2 ';

  @override
  String get registration_unlimited => 'riassunti illimitati';

  @override
  String get registration_summarizations => 'gratis';

  @override
  String get registration_name => 'Nome';

  @override
  String get registration_emailAddress => 'Indirizzo email';

  @override
  String get registration_password => 'Password';

  @override
  String get registration_confirmPassword => 'Conferma password';

  @override
  String get registration_register => 'Registrati';

  @override
  String get registration_orLoginWith => 'Oppure accedi con';

  @override
  String get registration_alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get registration_loginNow => 'Accedi ora';

  @override
  String get registration_passwordMismatch => 'Le password non corrispondono';

  @override
  String get request_secureSum => 'Riassunto sicuro';

  @override
  String get request_readMyBook => 'Leggi il mio libro';

  @override
  String get request_speechToText => 'Funzione da voce a testo';

  @override
  String get request_textToSpeech => 'Funzione da testo a voce';

  @override
  String get request_addLanguage => 'Aggiungi lingua';

  @override
  String get request_orWriteMessage => 'Oppure scrivici un messaggio';

  @override
  String get request_name => 'Nome';

  @override
  String get request_enterYourName => 'Inserisci il tuo nome';

  @override
  String get request_email => 'Email';

  @override
  String get request_enterYourEmail => 'Inserisci la tua email';

  @override
  String get request_message => 'Messaggio';

  @override
  String get request_enterYourRequest => 'Inserisci la tua richiesta';

  @override
  String get request_submit => 'Invia';

  @override
  String get request_selectLanguage => 'Seleziona lingua';

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
