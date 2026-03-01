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
import 'app_localizations_tr.dart';
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
    Locale('tr'),
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

  /// No description provided for @settings_group_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription & more'**
  String get settings_group_subscription;

  /// No description provided for @settings_group_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_group_about;

  /// No description provided for @settings_group_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_group_support;

  /// No description provided for @settings_group_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_group_account;

  /// No description provided for @settings_group_voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get settings_group_voice;

  /// No description provided for @wordTapHint_title.
  ///
  /// In en, this message translates to:
  /// **'Word translation'**
  String get wordTapHint_title;

  /// No description provided for @wordTapHint_message.
  ///
  /// In en, this message translates to:
  /// **'Tap a word to get its translation.'**
  String get wordTapHint_message;

  /// No description provided for @wordTapHint_dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get wordTapHint_dontShowAgain;

  /// No description provided for @wordTapHint_showLater.
  ///
  /// In en, this message translates to:
  /// **'Show later'**
  String get wordTapHint_showLater;

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
  /// **'1 week'**
  String get paywall_1WeekMultiline;

  /// No description provided for @paywall_1MonthMultiline.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get paywall_1MonthMultiline;

  /// No description provided for @paywall_12MonthsMultiline.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get paywall_12MonthsMultiline;

  /// No description provided for @paywall_accessAllPremiumCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Access all premium features! Cancel anytime'**
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
  /// **'Do you need success?'**
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
  /// **'Maximize your productivity and efficiency!'**
  String get offer_maximizeProductivityAndEfficiency;

  /// No description provided for @offer_getMoreInNoTime.
  ///
  /// In en, this message translates to:
  /// **'Get more in no time!'**
  String get offer_getMoreInNoTime;

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

  /// No description provided for @summary_couldNotOpenURL.
  ///
  /// In en, this message translates to:
  /// **'Could not open URL'**
  String get summary_couldNotOpenURL;

  /// No description provided for @summary_couldNotOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Could not open file'**
  String get summary_couldNotOpenFile;

  /// No description provided for @summary_originalFileNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'Original file is no longer available'**
  String get summary_originalFileNoLongerAvailable;

  /// No description provided for @summary_filePathNotFound.
  ///
  /// In en, this message translates to:
  /// **'File path not found'**
  String get summary_filePathNotFound;

  /// No description provided for @summary_originalTextNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Original text not available'**
  String get summary_originalTextNotAvailable;

  /// No description provided for @summary_breakThroughTheLimits.
  ///
  /// In en, this message translates to:
  /// **'Break through the limits'**
  String get summary_breakThroughTheLimits;

  /// No description provided for @summary_sourceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Source text is not available for this type of summary'**
  String get summary_sourceNotAvailable;

  /// No description provided for @research_chipAskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get research_chipAskQuestion;

  /// No description provided for @research_chipSuggestedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested questions'**
  String get research_chipSuggestedQuestions;

  /// No description provided for @research_suggestedQuestionsRequest.
  ///
  /// In en, this message translates to:
  /// **'Generate 5–7 specific questions worth asking about this document: for clarification, checking understanding, or discussion. Short list only.'**
  String get research_suggestedQuestionsRequest;

  /// No description provided for @research_chipPitfallsLimitations.
  ///
  /// In en, this message translates to:
  /// **'Pitfalls & limitations'**
  String get research_chipPitfallsLimitations;

  /// No description provided for @research_pitfallsLimitationsRequest.
  ///
  /// In en, this message translates to:
  /// **'List the main limitations, pitfalls, and risks mentioned in or implied by this document. Briefly, as bullet points.'**
  String get research_pitfallsLimitationsRequest;

  /// No description provided for @research_chipMermaidDiagram.
  ///
  /// In en, this message translates to:
  /// **'Mermaid diagram'**
  String get research_chipMermaidDiagram;

  /// No description provided for @research_diagramRequest.
  ///
  /// In en, this message translates to:
  /// **'Create a Mermaid diagram for this document'**
  String get research_diagramRequest;

  /// No description provided for @research_mermaidCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get research_mermaidCopy;

  /// No description provided for @research_mermaidOpenLive.
  ///
  /// In en, this message translates to:
  /// **'Open in Mermaid Live'**
  String get research_mermaidOpenLive;

  /// No description provided for @diagram_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get diagram_share;

  /// No description provided for @quiz_failedToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate quiz'**
  String get quiz_failedToGenerate;

  /// No description provided for @quiz_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quiz_retry;

  /// No description provided for @quiz_knowledgeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Quiz'**
  String get quiz_knowledgeQuiz;

  /// No description provided for @quiz_testYourUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'Test your understanding of this document'**
  String get quiz_testYourUnderstanding;

  /// No description provided for @quiz_questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get quiz_questions;

  /// No description provided for @quiz_estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get quiz_estimatedTime;

  /// No description provided for @quiz_minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get quiz_minutes;

  /// No description provided for @quiz_startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get quiz_startQuiz;

  /// No description provided for @quiz_explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get quiz_explanation;

  /// No description provided for @quiz_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get quiz_previous;

  /// No description provided for @quiz_viewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get quiz_viewResults;

  /// No description provided for @quiz_nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get quiz_nextQuestion;

  /// No description provided for @quiz_questionNofTotal.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quiz_questionNofTotal(Object current, Object total);

  /// No description provided for @quiz_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get quiz_overview;

  /// No description provided for @quiz_stepByStep.
  ///
  /// In en, this message translates to:
  /// **'Step by Step'**
  String get quiz_stepByStep;

  /// No description provided for @quiz_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent! 🎉'**
  String get quiz_excellent;

  /// No description provided for @quiz_goodJob.
  ///
  /// In en, this message translates to:
  /// **'Good job! 👍'**
  String get quiz_goodJob;

  /// No description provided for @quiz_notBad.
  ///
  /// In en, this message translates to:
  /// **'Not bad! Keep learning 📚'**
  String get quiz_notBad;

  /// No description provided for @quiz_keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing! 💪'**
  String get quiz_keepPracticing;

  /// No description provided for @quiz_correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get quiz_correct;

  /// No description provided for @quiz_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get quiz_incorrect;

  /// No description provided for @quiz_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get quiz_total;

  /// No description provided for @quiz_retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get quiz_retakeQuiz;

  /// No description provided for @quiz_reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get quiz_reviewAnswers;

  /// No description provided for @quiz_question.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String quiz_question(Object number);

  /// No description provided for @savedCards_title.
  ///
  /// In en, this message translates to:
  /// **'Saved Cards'**
  String get savedCards_title;

  /// No description provided for @savedCards_removeBookmarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark?'**
  String get savedCards_removeBookmarkTitle;

  /// No description provided for @savedCards_removeBookmarkMessage.
  ///
  /// In en, this message translates to:
  /// **'This card will be removed from your bookmarks.'**
  String get savedCards_removeBookmarkMessage;

  /// No description provided for @savedCards_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get savedCards_cancel;

  /// No description provided for @savedCards_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get savedCards_remove;

  /// No description provided for @savedCards_cardRemoved.
  ///
  /// In en, this message translates to:
  /// **'Card removed from bookmarks'**
  String get savedCards_cardRemoved;

  /// No description provided for @savedCards_sourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Source document not found'**
  String get savedCards_sourceNotFound;

  /// No description provided for @savedCards_clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get savedCards_clearAll;

  /// No description provided for @savedCards_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search saved cards...'**
  String get savedCards_searchHint;

  /// No description provided for @savedCards_cardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} card'**
  String savedCards_cardCount(Object count);

  /// No description provided for @savedCards_cardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String savedCards_cardsCount(Object count);

  /// No description provided for @savedCards_clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get savedCards_clearFilters;

  /// No description provided for @savedCards_noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved cards yet'**
  String get savedCards_noCardsYet;

  /// No description provided for @savedCards_saveCardsToAccess.
  ///
  /// In en, this message translates to:
  /// **'Save interesting cards to access them later'**
  String get savedCards_saveCardsToAccess;

  /// No description provided for @savedCards_noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get savedCards_noCardsFound;

  /// No description provided for @savedCards_tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get savedCards_tryAdjustingFilters;

  /// No description provided for @savedCards_clearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all saved cards?'**
  String get savedCards_clearAllTitle;

  /// No description provided for @savedCards_clearAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all your saved cards. This action cannot be undone.'**
  String get savedCards_clearAllMessage;

  /// No description provided for @savedCards_allCleared.
  ///
  /// In en, this message translates to:
  /// **'All saved cards cleared'**
  String get savedCards_allCleared;

  /// No description provided for @home_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get home_search;

  /// No description provided for @info_productivityInfo.
  ///
  /// In en, this message translates to:
  /// **'Productivity Info'**
  String get info_productivityInfo;

  /// No description provided for @info_words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get info_words;

  /// No description provided for @info_time.
  ///
  /// In en, this message translates to:
  /// **'Time, '**
  String get info_time;

  /// No description provided for @info_timeMin.
  ///
  /// In en, this message translates to:
  /// **'(min)'**
  String get info_timeMin;

  /// No description provided for @info_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved, '**
  String get info_saved;

  /// No description provided for @info_original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get info_original;

  /// No description provided for @info_brief.
  ///
  /// In en, this message translates to:
  /// **'Brief'**
  String get info_brief;

  /// No description provided for @info_deep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get info_deep;

  /// No description provided for @extension_growYourProductivity.
  ///
  /// In en, this message translates to:
  /// **'GROW YOUR PRODUCTIVITY'**
  String get extension_growYourProductivity;

  /// No description provided for @extension_copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get extension_copyLink;

  /// No description provided for @extension_sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get extension_sendLink;

  /// No description provided for @extension_enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get extension_enterYourEmail;

  /// No description provided for @auth_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get auth_skip;

  /// No description provided for @auth_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get auth_hello;

  /// No description provided for @auth_fillInToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Fill in to get started'**
  String get auth_fillInToGetStarted;

  /// No description provided for @auth_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_emailAddress;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_loginIn.
  ///
  /// In en, this message translates to:
  /// **'Login in'**
  String get auth_loginIn;

  /// No description provided for @auth_orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get auth_orLoginWith;

  /// No description provided for @auth_dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get auth_dontHaveAccount;

  /// No description provided for @auth_registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get auth_registerNow;

  /// No description provided for @auth_passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get auth_passwordCannotBeEmpty;

  /// No description provided for @auth_passwordMustBe6Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get auth_passwordMustBe6Chars;

  /// No description provided for @registration_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get registration_skip;

  /// No description provided for @registration_registerAndGet.
  ///
  /// In en, this message translates to:
  /// **'Register and get'**
  String get registration_registerAndGet;

  /// No description provided for @registration_2Free.
  ///
  /// In en, this message translates to:
  /// **'2 free '**
  String get registration_2Free;

  /// No description provided for @registration_1FreePerDay.
  ///
  /// In en, this message translates to:
  /// **'1 free per day'**
  String get registration_1FreePerDay;

  /// No description provided for @registration_unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get registration_unlimited;

  /// No description provided for @limit_onePerDay.
  ///
  /// In en, this message translates to:
  /// **'1 free summary per day'**
  String get limit_onePerDay;

  /// No description provided for @limit_resetsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Limit resets at midnight. You get 1 more free summary tomorrow.'**
  String get limit_resetsTomorrow;

  /// No description provided for @limit_usedTodayTryTomorrow.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used your 1 free summary today. Come back tomorrow for another one, or go unlimited.'**
  String get limit_usedTodayTryTomorrow;

  /// No description provided for @limit_blockedCardOverlay.
  ///
  /// In en, this message translates to:
  /// **'This summary was created over your daily limit. Unlock with Premium. Tomorrow you get 1 new free summary.'**
  String get limit_blockedCardOverlay;

  /// No description provided for @giftCode_menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Redeem gift code'**
  String get giftCode_menuTitle;

  /// No description provided for @giftCode_dialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter gift code'**
  String get giftCode_dialogTitle;

  /// No description provided for @giftCode_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get giftCode_placeholder;

  /// No description provided for @giftCode_activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get giftCode_activate;

  /// No description provided for @giftCode_success.
  ///
  /// In en, this message translates to:
  /// **'Gift code accepted. You received {count} documents.'**
  String giftCode_success(int count);

  /// No description provided for @giftCode_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid or already used code.'**
  String get giftCode_error;

  /// No description provided for @registration_summarizations.
  ///
  /// In en, this message translates to:
  /// **'summarizations'**
  String get registration_summarizations;

  /// No description provided for @registration_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get registration_name;

  /// No description provided for @registration_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get registration_emailAddress;

  /// No description provided for @registration_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registration_password;

  /// No description provided for @registration_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registration_confirmPassword;

  /// No description provided for @registration_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registration_register;

  /// No description provided for @registration_orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get registration_orLoginWith;

  /// No description provided for @registration_alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registration_alreadyHaveAccount;

  /// No description provided for @registration_loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get registration_loginNow;

  /// No description provided for @registration_passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password mismatch'**
  String get registration_passwordMismatch;

  /// No description provided for @request_secureSum.
  ///
  /// In en, this message translates to:
  /// **'Secure summarization'**
  String get request_secureSum;

  /// No description provided for @request_readMyBook.
  ///
  /// In en, this message translates to:
  /// **'Read my book'**
  String get request_readMyBook;

  /// No description provided for @request_speechToText.
  ///
  /// In en, this message translates to:
  /// **'Speech to text feature'**
  String get request_speechToText;

  /// No description provided for @request_textToSpeech.
  ///
  /// In en, this message translates to:
  /// **'Text to speech feature'**
  String get request_textToSpeech;

  /// No description provided for @request_addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add language'**
  String get request_addLanguage;

  /// No description provided for @request_orWriteMessage.
  ///
  /// In en, this message translates to:
  /// **'Or write us a message'**
  String get request_orWriteMessage;

  /// No description provided for @request_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get request_name;

  /// No description provided for @request_enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get request_enterYourName;

  /// No description provided for @request_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get request_email;

  /// No description provided for @request_enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get request_enterYourEmail;

  /// No description provided for @request_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get request_message;

  /// No description provided for @request_enterYourRequest.
  ///
  /// In en, this message translates to:
  /// **'Enter your request'**
  String get request_enterYourRequest;

  /// No description provided for @request_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get request_submit;

  /// No description provided for @request_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get request_selectLanguage;

  /// No description provided for @ttsDownloadDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading voice model'**
  String get ttsDownloadDialogTitle;

  /// No description provided for @ttsDownloadDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Please keep the app open while we download the voice resources.'**
  String get ttsDownloadDialogBody;

  /// No description provided for @ttsModelReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice model ready'**
  String get ttsModelReadyTitle;

  /// No description provided for @ttsModelReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice model downloaded successfully. You can choose a voice in Settings.'**
  String get ttsModelReadyMessage;

  /// No description provided for @knowledgeCards_regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get knowledgeCards_regenerate;

  /// No description provided for @knowledgeCards_regenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate knowledge cards?'**
  String get knowledgeCards_regenerateTitle;

  /// No description provided for @knowledgeCards_regenerateMessage.
  ///
  /// In en, this message translates to:
  /// **'Your current cards will be removed and new ones will be generated. Continue?'**
  String get knowledgeCards_regenerateMessage;

  /// No description provided for @knowledgeCards_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get knowledgeCards_cancel;

  /// No description provided for @knowledgeCards_voiceAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you understand the term \"{term}\"?'**
  String knowledgeCards_voiceAnswerTitle(Object term);

  /// No description provided for @knowledgeCards_voiceAnswerTask.
  ///
  /// In en, this message translates to:
  /// **'Explain in your own words'**
  String get knowledgeCards_voiceAnswerTask;

  /// No description provided for @knowledgeCards_voiceAnswerSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get knowledgeCards_voiceAnswerSend;

  /// No description provided for @knowledgeCards_voiceAnswerStubMessage.
  ///
  /// In en, this message translates to:
  /// **'Verification of your answer will be available in the app soon.'**
  String get knowledgeCards_voiceAnswerStubMessage;

  /// No description provided for @knowledgeCards_voiceAnswerError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify the answer. Check your connection and try again.'**
  String get knowledgeCards_voiceAnswerError;

  /// No description provided for @knowledgeCards_tapMicToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone to speak'**
  String get knowledgeCards_tapMicToSpeak;

  /// No description provided for @knowledgeCards_listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get knowledgeCards_listening;
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
    'tr',
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
    case 'tr':
      return AppLocalizationsTr();
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
