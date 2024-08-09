import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';

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
        "Screen": event.screen,
        'Test version': settingsBloc.state.abTest,
        'Screen link': settingsBloc.state.abTest == 'A'
            ? subscriptionALink
            : subscriptionBLink
      });
    });
    on<SubScreenLimShow>((event, emit) {
      mixpanel.track('Subscription screen show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
      });
    });
    on<BundleScreenLimShow>((event, emit) {
      mixpanel.track('Bundle screen from settings show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
      });
    });
    on<BundleScreenLim1Show>((event, emit) {
      mixpanel.track('Bundle screen from onboarding show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
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
    // on<SummarizingStarted>((event, emit) {
    //   final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
    //   mixpanel.track('summarizing_started',
    //       properties: {'language': '??', 'resource': res});
    // });

    on<SummarizingSuccess>((event, emit) {
      mixpanel.track('summarizing_success', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare
      });
    });

    on<SummarizingError>((event, emit) {
      mixpanel.track('summarizing_error', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare,
        'error': event.error
      });
    });

    on<LimitReached>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('limit_reached',
          properties: {'registrated': event.registrated, 'resource': res});
    });

    on<SummaryUpgrade>((event, emit) {
      mixpanel.track('upgrade', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare
      });
    });

    on<ShowSummaryAgain>((event, emit) {
      mixpanel.track('show_summary_again', properties: {
        'language': '??',
        'url': event.url,
      });
    });

    on<SummaryScroll>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      mixpanel.track('summary_scroll',
          properties: {'language': '??', 'resource': res});
    });

    on<ReadSummary>((event, emit) {
      mixpanel.track('read_summary', properties: {
        'summary_type': event.type,
        'summary_url': event.url,
        'AB': event.AB
      });
    });

    on<TrackResearchSummary>((event, emit) {
      mixpanel.track('research_summary', properties: {
        'summary_url': event.url,
      });
    });

    on<TrackTranslateSummary>((event, emit) {
      mixpanel.track('translate_summary', properties: {
        'summary_url': event.url,
      });
    });

    on<RedirectToSummifyExtension>((event, emit) {
      mixpanel.track('open_extension_link', properties: {});
    });

    on<CopySummifyExtensionLink>((event, emit) {
      mixpanel.track('copy_extension_link', properties: {});
    });
    on<OpenSummifyExtensionModal>((event, emit) {
      mixpanel.track('open_extension_modal', properties: {});
    });
  }
}
