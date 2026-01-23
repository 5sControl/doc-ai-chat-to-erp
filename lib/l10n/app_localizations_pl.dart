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
  String get settings_general => 'Ogólne';

  @override
  String get settings_interfaceLanguage => 'Język interfejsu';

  @override
  String get settings_translationLanguage => 'Język tłumaczenia';

  @override
  String get settings_selectLanguageTitle => 'Wybierz język';

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
  String get paywall_1WeekMultiline => '1 \\ntydzień';

  @override
  String get paywall_1MonthMultiline => '1 \\nmiesiąc';

  @override
  String get paywall_12MonthsMultiline => '12 \\nmiesięcy';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Dostęp do wszystkich funkcji premium!\\nAnuluj w dowolnym momencie';

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
  String get offer_needMoreSummaries => 'Potrzebujesz więcej podsumowań?';

  @override
  String get offer_maximizeYourProductivity => 'Zwiększ swoją produktywność!';

  @override
  String get offer_outOfSummaries => 'Brak podsumowań?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Zwiększ produktywność\\ni efektywność!';

  @override
  String get offer_getMoreInNoTime => 'Zyskaj więcej w mgnieniu oka!';

  @override
  String get offer_15DeepSummariesDaily =>
      '15 szczegółowych podsumowań dziennie';

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
}
