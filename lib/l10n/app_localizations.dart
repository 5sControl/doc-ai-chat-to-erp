import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
  ];

  /// No description provided for @common_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// No description provided for @common_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get common_select;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @onboarding_translateSummarizationTo.
  ///
  /// In en, this message translates to:
  /// **'Translate summarization to'**
  String get onboarding_translateSummarizationTo;

  /// No description provided for @onboarding_goodbyeInfoOverload.
  ///
  /// In en, this message translates to:
  /// **'Goodbye information overload!'**
  String get onboarding_goodbyeInfoOverload;

  /// No description provided for @onboarding_oneClickShareToGetSummary.
  ///
  /// In en, this message translates to:
  /// **'One-click \"share\" to get summary'**
  String get onboarding_oneClickShareToGetSummary;

  /// No description provided for @onboarding_welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Summify'**
  String get onboarding_welcomeTitle;

  /// No description provided for @onboarding_welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal AI Summarizer'**
  String get onboarding_welcomeSubtitle;

  /// No description provided for @settings_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settings_profile;

  /// No description provided for @settings_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_general;

  /// No description provided for @settings_interfaceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get settings_interfaceLanguage;

  /// No description provided for @settings_translationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Translation language'**
  String get settings_translationLanguage;

  /// No description provided for @settings_selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get settings_selectLanguageTitle;

  /// No description provided for @paywall_beSmartWithYourTime.
  ///
  /// In en, this message translates to:
  /// **'Be smart with your time!'**
  String get paywall_beSmartWithYourTime;

  /// No description provided for @paywall_payWeekly.
  ///
  /// In en, this message translates to:
  /// **'Pay weekly'**
  String get paywall_payWeekly;

  /// No description provided for @paywall_payAnnually.
  ///
  /// In en, this message translates to:
  /// **'Pay annually'**
  String get paywall_payAnnually;

  /// No description provided for @paywall_saveUpTo.
  ///
  /// In en, this message translates to:
  /// **'Save up to {amount}\\\$'**
  String paywall_saveUpTo(Object amount);

  /// No description provided for @paywall_buy.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get paywall_buy;

  /// No description provided for @paywall_andGetOn.
  ///
  /// In en, this message translates to:
  /// **'AND GET ON'**
  String get paywall_andGetOn;

  /// No description provided for @paywall_forFree.
  ///
  /// In en, this message translates to:
  /// **'FOR FREE!'**
  String get paywall_forFree;

  /// No description provided for @paywall_12Months.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get paywall_12Months;

  /// No description provided for @paywall_1Week.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get paywall_1Week;

  /// No description provided for @paywall_1Month.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get paywall_1Month;

  /// No description provided for @paywall_1WeekMultiline.
  ///
  /// In en, this message translates to:
  /// **'1 \\nweek'**
  String get paywall_1WeekMultiline;

  /// No description provided for @paywall_1MonthMultiline.
  ///
  /// In en, this message translates to:
  /// **'1 \\nmonth'**
  String get paywall_1MonthMultiline;

  /// No description provided for @paywall_12MonthsMultiline.
  ///
  /// In en, this message translates to:
  /// **'12 \\nmonths'**
  String get paywall_12MonthsMultiline;

  /// No description provided for @paywall_accessAllPremiumCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Access all premium features!\\nCancel anytime'**
  String get paywall_accessAllPremiumCancelAnytime;

  /// No description provided for @paywall_pricePerYear.
  ///
  /// In en, this message translates to:
  /// **'{price}/year'**
  String paywall_pricePerYear(Object price);

  /// No description provided for @paywall_pricePerWeek.
  ///
  /// In en, this message translates to:
  /// **'{price}/week'**
  String paywall_pricePerWeek(Object price);

  /// No description provided for @paywall_termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get paywall_termsOfUse;

  /// No description provided for @paywall_restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get paywall_restorePurchase;

  /// No description provided for @paywall_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get paywall_privacyPolicy;

  /// No description provided for @paywall_unlimitedSummaries.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Summaries'**
  String get paywall_unlimitedSummaries;

  /// No description provided for @paywall_documentResearch.
  ///
  /// In en, this message translates to:
  /// **'Document Research'**
  String get paywall_documentResearch;

  /// No description provided for @paywall_briefAndDeepSummary.
  ///
  /// In en, this message translates to:
  /// **'Brief and Deep Summary'**
  String get paywall_briefAndDeepSummary;

  /// No description provided for @paywall_translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get paywall_translation;

  /// No description provided for @paywall_addToChromeForFree.
  ///
  /// In en, this message translates to:
  /// **'Add to Chrome for FREE'**
  String get paywall_addToChromeForFree;

  /// No description provided for @offer_needMoreSummaries.
  ///
  /// In en, this message translates to:
  /// **'Need more summaries?'**
  String get offer_needMoreSummaries;

  /// No description provided for @offer_maximizeYourProductivity.
  ///
  /// In en, this message translates to:
  /// **'Maximize your productivity!'**
  String get offer_maximizeYourProductivity;

  /// No description provided for @offer_outOfSummaries.
  ///
  /// In en, this message translates to:
  /// **'Out of Summaries?'**
  String get offer_outOfSummaries;

  /// No description provided for @offer_maximizeProductivityAndEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Maximize your productivity\\nand efficiency!'**
  String get offer_maximizeProductivityAndEfficiency;

  /// No description provided for @offer_getMoreInNoTime.
  ///
  /// In en, this message translates to:
  /// **'Get more in no time!'**
  String get offer_getMoreInNoTime;

  /// No description provided for @offer_15DeepSummariesDaily.
  ///
  /// In en, this message translates to:
  /// **'15 Deep Summaries Daily'**
  String get offer_15DeepSummariesDaily;

  /// No description provided for @offer_goUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Go Unlimited'**
  String get offer_goUnlimited;

  /// No description provided for @bundle_subscriptionsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions not available'**
  String get bundle_subscriptionsNotAvailable;

  /// No description provided for @bundle_getForFree.
  ///
  /// In en, this message translates to:
  /// **'GET FOR FREE'**
  String get bundle_getForFree;

  /// No description provided for @bundle_on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get bundle_on;

  /// No description provided for @bundle_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get bundle_version;

  /// No description provided for @bundle_offer_unlockLimitless.
  ///
  /// In en, this message translates to:
  /// **'Unlock Limitless'**
  String get bundle_offer_unlockLimitless;

  /// No description provided for @bundle_offer_possibilities.
  ///
  /// In en, this message translates to:
  /// **'Possibilities'**
  String get bundle_offer_possibilities;

  /// No description provided for @bundle_offer_endlessPossibilities.
  ///
  /// In en, this message translates to:
  /// **'Endless Possibilities'**
  String get bundle_offer_endlessPossibilities;

  /// No description provided for @bundle_offer_with50Off.
  ///
  /// In en, this message translates to:
  /// **'with 50% Off'**
  String get bundle_offer_with50Off;

  /// No description provided for @bundle_offer_get4UnlimitedApps.
  ///
  /// In en, this message translates to:
  /// **'Get 4 Unlimited Apps'**
  String get bundle_offer_get4UnlimitedApps;

  /// No description provided for @bundle_tabBundle.
  ///
  /// In en, this message translates to:
  /// **'Bundle'**
  String get bundle_tabBundle;

  /// No description provided for @bundle_tabUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get bundle_tabUnlimited;

  /// No description provided for @purchase_youAreTheBest.
  ///
  /// In en, this message translates to:
  /// **'You are the best!'**
  String get purchase_youAreTheBest;

  /// No description provided for @purchase_get.
  ///
  /// In en, this message translates to:
  /// **'Get'**
  String get purchase_get;

  /// No description provided for @purchase_versionForFree.
  ///
  /// In en, this message translates to:
  /// **'version for free!'**
  String get purchase_versionForFree;

  /// No description provided for @purchase_copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get purchase_copyLink;

  /// No description provided for @purchase_collectYourGift.
  ///
  /// In en, this message translates to:
  /// **'Collect your gift'**
  String get purchase_collectYourGift;

  /// No description provided for @purchase_enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get purchase_enterYourEmail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'pt',
    'ru',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
