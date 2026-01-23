// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get common_continue => 'Continuer';

  @override
  String get common_select => 'Sélectionner';

  @override
  String get common_ok => 'OK';

  @override
  String get common_error => 'Erreur';

  @override
  String get onboarding_translateSummarizationTo => 'Traduire les résumés en';

  @override
  String get onboarding_goodbyeInfoOverload =>
      'Adieu à la surcharge d’informations !';

  @override
  String get onboarding_oneClickShareToGetSummary =>
      'Un clic sur « Partager » pour obtenir un résumé';

  @override
  String get onboarding_welcomeTitle => 'Bienvenue sur Summify';

  @override
  String get onboarding_welcomeSubtitle => 'Résumeur IA personnel';

  @override
  String get settings_profile => 'Profil';

  @override
  String get settings_general => 'Général';

  @override
  String get settings_interfaceLanguage => 'Langue de l’interface';

  @override
  String get settings_translationLanguage => 'Langue de traduction';

  @override
  String get settings_selectLanguageTitle => 'Choisir la langue';

  @override
  String get paywall_beSmartWithYourTime => 'Optimisez votre temps !';

  @override
  String get paywall_payWeekly => 'Payer chaque semaine';

  @override
  String get paywall_payAnnually => 'Payer chaque année';

  @override
  String paywall_saveUpTo(Object amount) {
    return 'Économisez jusqu’à $amount\\\$';
  }

  @override
  String get paywall_buy => 'ACHETER';

  @override
  String get paywall_andGetOn => 'ET OBTENIR SUR';

  @override
  String get paywall_forFree => 'GRATUITEMENT !';

  @override
  String get paywall_12Months => '12 mois';

  @override
  String get paywall_1Week => '1 semaine';

  @override
  String get paywall_1Month => '1 mois';

  @override
  String get paywall_1WeekMultiline => '1 \\nsemaine';

  @override
  String get paywall_1MonthMultiline => '1 \\nmois';

  @override
  String get paywall_12MonthsMultiline => '12 \\nmois';

  @override
  String get paywall_accessAllPremiumCancelAnytime =>
      'Accédez à toutes les fonctionnalités premium !\\nAnnulez à tout moment';

  @override
  String paywall_pricePerYear(Object price) {
    return '$price/an';
  }

  @override
  String paywall_pricePerWeek(Object price) {
    return '$price/semaine';
  }

  @override
  String get paywall_termsOfUse => 'Conditions d’utilisation';

  @override
  String get paywall_restorePurchase => 'Restaurer l’achat';

  @override
  String get paywall_privacyPolicy => 'Politique de confidentialité';

  @override
  String get paywall_unlimitedSummaries => 'Résumés illimités';

  @override
  String get paywall_documentResearch => 'Recherche de documents';

  @override
  String get paywall_briefAndDeepSummary => 'Résumé court et approfondi';

  @override
  String get paywall_translation => 'Traduction';

  @override
  String get paywall_addToChromeForFree => 'Ajouter à Chrome GRATUITEMENT';

  @override
  String get offer_needMoreSummaries => 'Besoin de plus de résumés ?';

  @override
  String get offer_maximizeYourProductivity => 'Maximisez votre productivité !';

  @override
  String get offer_outOfSummaries => 'Plus de résumés ?';

  @override
  String get offer_maximizeProductivityAndEfficiency =>
      'Maximisez votre productivité\\net votre efficacité !';

  @override
  String get offer_getMoreInNoTime => 'Faites-en plus en un rien de temps !';

  @override
  String get offer_15DeepSummariesDaily => '15 résumés approfondis par jour';

  @override
  String get offer_goUnlimited => 'Passer en illimité';

  @override
  String get bundle_subscriptionsNotAvailable => 'Abonnements indisponibles';

  @override
  String get bundle_getForFree => 'OBTENIR GRATUITEMENT';

  @override
  String get bundle_on => 'sur';

  @override
  String get bundle_version => 'Version';

  @override
  String get bundle_offer_unlockLimitless => 'Débloquez des';

  @override
  String get bundle_offer_possibilities => 'possibilités illimitées';

  @override
  String get bundle_offer_endlessPossibilities => 'Possibilités infinies';

  @override
  String get bundle_offer_with50Off => 'avec -50%';

  @override
  String get bundle_offer_get4UnlimitedApps => 'Obtenez 4 apps illimitées';

  @override
  String get bundle_tabBundle => 'Pack';

  @override
  String get bundle_tabUnlimited => 'Illimité';

  @override
  String get purchase_youAreTheBest => 'Vous êtes le meilleur !';

  @override
  String get purchase_get => 'Obtenez';

  @override
  String get purchase_versionForFree => 'la version gratuitement !';

  @override
  String get purchase_copyLink => 'Copier le lien';

  @override
  String get purchase_collectYourGift => 'Récupérer votre cadeau';

  @override
  String get purchase_enterYourEmail => 'Entrez votre e-mail';
}
