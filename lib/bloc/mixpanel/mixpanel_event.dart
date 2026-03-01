part of 'mixpanel_bloc.dart';

sealed class MixpanelEvent extends Equatable {
  const MixpanelEvent();
}

// SCREEN TRACKING
class ScreenView extends MixpanelEvent {
  final String screenName;
  const ScreenView({required this.screenName});
  @override
  List<Object?> get props => [screenName];
}

// USER IDENTIFICATION
class IdentifyUser extends MixpanelEvent {
  final String uid;
  final String? email;
  const IdentifyUser({required this.uid, this.email});
  @override
  List<Object?> get props => [uid, email];
}

// APP

class OnboardingStep extends MixpanelEvent {
  final int step;
  const OnboardingStep({required this.step});

  @override
  List<Object?> get props => [step];
}

class PaywallShow extends MixpanelEvent {
  // Trigger: onboarding/settings
  final String screen;
  final String trigger;
  const PaywallShow({
    required this.trigger,
    required this.screen,
  });

  @override
  List<Object?> get props => [trigger];
}

class SubScreenLimShow extends MixpanelEvent {
  // Trigger: onboarding/settings
  final String screen;
  final String trigger;
  const SubScreenLimShow({
    required this.trigger,
    required this.screen,
  });

  @override
  List<Object?> get props => [trigger, screen];
}

class BundleScreenLimShow extends MixpanelEvent {
  // Trigger: onboarding/settings
  final String screen;
  final String trigger;
  const BundleScreenLimShow({
    required this.trigger,
    required this.screen,
  });

  @override
  List<Object?> get props => [trigger, screen];
}

class BundleScreenLim1Show extends MixpanelEvent {
  // Trigger: onboarding/settings
  final String screen;
  final String trigger;
  const BundleScreenLim1Show({
    required this.trigger,
    required this.screen,
  });

  @override
  List<Object?> get props => [trigger, screen];
}

class ActivateSubscription extends MixpanelEvent {
  final String plan;
  // Subscription: week, month, year
  const ActivateSubscription({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class ClosePaywall extends MixpanelEvent {
  const ClosePaywall();

  @override
  List<Object?> get props => [];
}

class ShowInstructions extends MixpanelEvent {
  const ShowInstructions();

  @override
  List<Object?> get props => [];
}

class CloseInstructions extends MixpanelEvent {
  const CloseInstructions();

  @override
  List<Object?> get props => [];
}

class SelectOption extends MixpanelEvent {
  final String option;
  // Option: link, file, text
  const SelectOption({required this.option});

  @override
  List<Object?> get props => [option];
}

class Summify extends MixpanelEvent {
  final String option;
  const Summify({required this.option});

  @override
  List<Object?> get props => [option];
}

class SummifyError extends MixpanelEvent {
  final String option;
  const SummifyError({required this.option});

  @override
  List<Object?> get props => [option];
}

class SummifySuccess extends MixpanelEvent {
  final String option;
  const SummifySuccess({required this.option});

  @override
  List<Object?> get props => [option];
}

class OpenSummary extends MixpanelEvent {
  const OpenSummary();

  @override
  List<Object?> get props => [];
}

class DeleteSummaryM extends MixpanelEvent {
  const DeleteSummaryM();

  @override
  List<Object?> get props => [];
}

class CopySummary extends MixpanelEvent {
  const CopySummary();

  @override
  List<Object?> get props => [];
}

class ShareSummary extends MixpanelEvent {
  const ShareSummary();

  @override
  List<Object?> get props => [];
}

// EXTENSION

// class SummarizingStarted extends MixpanelEvent {
//   final String resource;
//   const SummarizingStarted({required this.resource});
//
//   @override
//   List<Object?> get props => [resource];
// }

class SummarizingSuccess extends MixpanelEvent {
  final String url;
  final bool fromShare;
  const SummarizingSuccess({required this.url, required this.fromShare});

  @override
  List<Object?> get props => [url, fromShare];
}

class SummarizingError extends MixpanelEvent {
  final String url;
  final bool fromShare;
  final String error;
  const SummarizingError(
      {required this.url, required this.fromShare, required this.error});

  @override
  List<Object?> get props => [url, fromShare, error];
}

class ShowSummaryAgain extends MixpanelEvent {
  final String url;
  const ShowSummaryAgain({required this.url});

  @override
  List<Object?> get props => [url];
}

class SummaryScroll extends MixpanelEvent {
  final String resource;
  const SummaryScroll({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class SummaryUpgrade extends MixpanelEvent {
  final String url;
  final bool fromShare;
  const SummaryUpgrade({required this.url, required this.fromShare});

  @override
  List<Object?> get props => [url, fromShare];
}

class LimitReached extends MixpanelEvent {
  final String resource;
  final bool registrated;
  const LimitReached({required this.resource, required this.registrated});

  @override
  List<Object?> get props => [resource, registrated];
}

class ReadSummary extends MixpanelEvent {
  final String url;
  final String type; // short / long
  final String AB;
  const ReadSummary({required this.type, required this.url, required this.AB});

  @override
  List<Object?> get props => [type, url, AB];
}

class TrackResearchSummary extends MixpanelEvent {
  final String url;
  final String? error;
  const TrackResearchSummary({this.error, required this.url});

  @override
  List<Object?> get props => [url];
}

class TrackTranslateSummary extends MixpanelEvent {
  final String url;
  final String? error;
  const TrackTranslateSummary({this.error, required this.url});

  @override
  List<Object?> get props => [url];
}

class RedirectToSummifyExtension extends MixpanelEvent {
  const RedirectToSummifyExtension();

  @override
  List<Object?> get props => [];
}

class CopySummifyExtensionLink extends MixpanelEvent {
  const CopySummifyExtensionLink();

  @override
  List<Object?> get props => [];
}

class OpenSummifyExtensionModal extends MixpanelEvent {
  const OpenSummifyExtensionModal();

  @override
  List<Object?> get props => [];
}

/// Fired when knowledge cards were extracted via API.
class KnowledgeCardsExtracted extends MixpanelEvent {
  final String summaryKey;
  final int cardsCount;

  const KnowledgeCardsExtracted({
    required this.summaryKey,
    required this.cardsCount,
  });

  @override
  List<Object?> get props => [summaryKey, cardsCount];
}

class KnowledgeCardsExtractionError extends MixpanelEvent {
  final String summaryKey;
  final String error;

  const KnowledgeCardsExtractionError({
    required this.summaryKey,
    required this.error,
  });

  @override
  List<Object?> get props => [summaryKey, error];
}

class KnowledgeCardSaved extends MixpanelEvent {
  final String summaryKey;
  final String cardId;

  const KnowledgeCardSaved({
    required this.summaryKey,
    required this.cardId,
  });

  @override
  List<Object?> get props => [summaryKey, cardId];
}

class KnowledgeCardUnsaved extends MixpanelEvent {
  final String summaryKey;
  final String cardId;

  const KnowledgeCardUnsaved({
    required this.summaryKey,
    required this.cardId,
  });

  @override
  List<Object?> get props => [summaryKey, cardId];
}

class KnowledgeCardsUnsupportedDevice extends MixpanelEvent {
  final String summaryKey;

  const KnowledgeCardsUnsupportedDevice({
    required this.summaryKey,
  });

  @override
  List<Object?> get props => [summaryKey];
}

class KnowledgeCardsTabOpen extends MixpanelEvent {
  final String summaryKey;
  const KnowledgeCardsTabOpen({required this.summaryKey});
  @override
  List<Object?> get props => [summaryKey];
}

class KnowledgeCardOpen extends MixpanelEvent {
  final String cardId;
  final String summaryKey;
  const KnowledgeCardOpen({required this.cardId, required this.summaryKey});
  @override
  List<Object?> get props => [cardId, summaryKey];
}

class KnowledgeCardVoiceCheckOpen extends MixpanelEvent {
  final String cardId;
  final String summaryKey;
  const KnowledgeCardVoiceCheckOpen({
    required this.cardId,
    required this.summaryKey,
  });
  @override
  List<Object?> get props => [cardId, summaryKey];
}

class KnowledgeCardVoiceCheckSent extends MixpanelEvent {
  final String cardId;
  final String summaryKey;
  final int? accuracy;
  const KnowledgeCardVoiceCheckSent({
    required this.cardId,
    required this.summaryKey,
    this.accuracy,
  });
  @override
  List<Object?> get props => [cardId, summaryKey, accuracy];
}

class KnowledgeCardsRegenerateRequested extends MixpanelEvent {
  final String summaryKey;
  const KnowledgeCardsRegenerateRequested({required this.summaryKey});
  @override
  List<Object?> get props => [summaryKey];
}

// SAVED CARDS SCREEN
class SavedCardsScreenOpen extends MixpanelEvent {
  const SavedCardsScreenOpen();
  @override
  List<Object?> get props => [];
}

class SavedCardView extends MixpanelEvent {
  final String cardId;
  final String? summaryKey;
  const SavedCardView({required this.cardId, this.summaryKey});
  @override
  List<Object?> get props => [cardId, summaryKey];
}

class SavedCardRemoved extends MixpanelEvent {
  final String cardId;
  final String? summaryKey;
  const SavedCardRemoved({required this.cardId, this.summaryKey});
  @override
  List<Object?> get props => [cardId, summaryKey];
}

// QUIZ
class QuizTabOpen extends MixpanelEvent {
  final String documentKey;
  const QuizTabOpen({required this.documentKey});
  @override
  List<Object?> get props => [documentKey];
}

class QuizStarted extends MixpanelEvent {
  final String documentKey;
  final int questionsCount;
  const QuizStarted({required this.documentKey, required this.questionsCount});
  @override
  List<Object?> get props => [documentKey, questionsCount];
}

class TrackQuizAnswer extends MixpanelEvent {
  final String documentKey;
  final bool correct;
  const TrackQuizAnswer({required this.documentKey, required this.correct});
  @override
  List<Object?> get props => [documentKey, correct];
}

class QuizCompleted extends MixpanelEvent {
  final String documentKey;
  final int scorePercent;
  final int correctCount;
  final int total;
  const QuizCompleted({
    required this.documentKey,
    required this.scorePercent,
    required this.correctCount,
    required this.total,
  });
  @override
  List<Object?> get props => [documentKey, scorePercent, correctCount, total];
}

class QuizRetake extends MixpanelEvent {
  final String documentKey;
  const QuizRetake({required this.documentKey});
  @override
  List<Object?> get props => [documentKey];
}

class QuizRegenerateRequested extends MixpanelEvent {
  final String documentKey;
  const QuizRegenerateRequested({required this.documentKey});
  @override
  List<Object?> get props => [documentKey];
}
