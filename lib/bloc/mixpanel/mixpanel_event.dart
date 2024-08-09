part of 'mixpanel_bloc.dart';

sealed class MixpanelEvent extends Equatable {
  const MixpanelEvent();
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

// class Summify extends MixpanelEvent {
//   final String option;
//   // Option: link, file, text
//   final String url;
//   const Summify({required this.option, required this.url});
//
//   @override
//   List<Object?> get props => [option, url];
// }

// class SummifyError extends MixpanelEvent {
//   final String option;
//   final String url;
//   const SummifyError({required this.option, required this.url});
//
//   @override
//   List<Object?> get props => [option, url];
// }

// class SummifySuccess extends MixpanelEvent {
//   final String option;
//   // Option: link, file, text
//   final String url;
//   const SummifySuccess({required this.option, required this.url});
//
//   @override
//   List<Object?> get props => [option, url];
// }

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
