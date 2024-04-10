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
  final String trigger;
  const PaywallShow({required this.trigger});

  @override
  List<Object?> get props => [trigger];
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
  // Option: link, file, text
  const Summify({required this.option});

  @override
  List<Object?> get props => [option];
}

class SummifyError extends MixpanelEvent {
  final String option;
  // Option: link, file, text
  const SummifyError({required this.option});

  @override
  List<Object?> get props => [option];
}

class SummifySuccess extends MixpanelEvent {
  final String option;
  // Option: link, file, text
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

class SummarizingStarted extends MixpanelEvent {
  final String resource;
  const SummarizingStarted({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class SummarizingSuccess extends MixpanelEvent {
  final String resource;
  const SummarizingSuccess({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class ShowSummaryAgain extends MixpanelEvent {
  final String resource;
  const ShowSummaryAgain({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class SummaryScroll extends MixpanelEvent {
  final String resource;
  const SummaryScroll({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class SummaryUpgrade extends MixpanelEvent {
  final String resource;
  const SummaryUpgrade({required this.resource});

  @override
  List<Object?> get props => [resource];
}

class LimitReached extends MixpanelEvent {
  final String resource;
  final bool registrated;
  const LimitReached({required this.resource, required this.registrated});

  @override
  List<Object?> get props => [resource, registrated];
}
