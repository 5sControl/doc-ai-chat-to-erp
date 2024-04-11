import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';

part 'mixpanel_event.dart';
part 'mixpanel_state.dart';

const subscriptionALink =
    'https://www.figma.com/file/2Rz4IcpAXkHalZP2ivDIIi/Sumishare?type=design&node-id=901-4041&mode=dev';
const subscriptionBLink =
    'https://www.figma.com/file/2Rz4IcpAXkHalZP2ivDIIi/Sumishare?type=design&node-id=933-4343&mode=dev';

class MixpanelBloc extends Bloc<MixpanelEvent, MixpanelState> {
  final SettingsBloc settingsBloc;
  late Mixpanel mixpanel;

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init(
      '8f439a0a80153cf8bf5c65f21d7126d6',
      trackAutomaticEvents: false,
    );
  }

  MixpanelBloc({required this.settingsBloc}) : super(const MixpanelState()) {
    initMixpanel();
    // APP
    on<OnboardingStep>((event, emit) {
      mixpanel.track('Onboarding step', properties: {'Step': event.step});
    });
    on<PaywallShow>((event, emit) {
      mixpanel.track('Paywall show', properties: {
        'Trigger': event.trigger,
        'Test version': settingsBloc.state.abTest,
        'Screen link': settingsBloc.state.abTest == 'A'
            ? subscriptionALink
            : subscriptionBLink
      });
    });
    on<ActivateSubscription>((event, emit) {
      mixpanel.track('Activate subscription', properties: {
        'Subscription': event.plan,
        'Test version': settingsBloc.state.abTest,
        'Screen link': settingsBloc.state.abTest == 'A'
            ? subscriptionALink
            : subscriptionBLink
      });
    });
    on<ClosePaywall>((event, emit) {
      mixpanel.track('Close paywall');
    });
    on<ShowInstructions>((event, emit) {
      mixpanel.track('Show instructions');
    });
    on<CloseInstructions>((event, emit) {
      mixpanel.track('Сlose instructions');
    });
    on<SelectOption>((event, emit) {
      mixpanel.track('Select option', properties: {'Option': event.option});
    });
    on<Summify>((event, emit) {
      mixpanel.track('Summify', properties: {'Option': event.option});
    });
    on<SummifyError>((event, emit) {
      mixpanel.track('Summify error', properties: {'Option': event.option,});
    });
    on<SummifySuccess>((event, emit) {
      mixpanel.track('Summify success', properties: {'Option': event.option});
    });
    on<OpenSummary>((event, emit) {
      mixpanel.track('Open summary');
    });
    on<DeleteSummaryM>((event, emit) {
      mixpanel.track('Delete summary');
    });
    on<CopySummary>((event, emit) {
      mixpanel.track('Copy summary');
    });
    on<ShareSummary>((event, emit) {
      mixpanel.track('Share summary');
    });
    // EXTENSION
    on<SummarizingStarted>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('summarizing_started',
          properties: {'language': '??', 'resource': res});
    });

    on<SummarizingSuccess>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('summarizing_success',
          properties: {'language': '??', 'resource': res});
    });

    on<LimitReached>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('limit_reached',
          properties: {'registrated': event.registrated, 'resource': res});
    });

    on<SummaryUpgrade>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel
          .track('upgrade', properties: {'language': '??', 'resource': res});
    });

    on<ShowSummaryAgain>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('show_summary_again',
          properties: {'language': '??', 'resource': res});
    });

    on<SummaryScroll>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('summary_scroll',
          properties: {'language': '??', 'resource': res});
    });
  }
}
