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
  Mixpanel? _mixpanel;

  Future<void> initMixpanel() async {
    _mixpanel = await Mixpanel.init(
      '8f439a0a80153cf8bf5c65f21d7126d6',
      trackAutomaticEvents: false,
    );
  }

  MixpanelBloc({required this.settingsBloc}) : super(const MixpanelState()) {
    initMixpanel();
    on<ScreenView>((event, emit) {
      _mixpanel?.track('screen_view', properties: {'screen_name': event.screenName});
    });
    on<IdentifyUser>((event, emit) {
      _mixpanel?.identify(event.uid);
      if (event.email != null && event.email!.isNotEmpty) {
        _mixpanel?.getPeople().set('email', event.email);
      }
    });
    // APP
    on<OnboardingStep>((event, emit) {
      _mixpanel?.track('Onboarding step', properties: {'Step': event.step});
    });
    on<PaywallShow>((event, emit) {
      _mixpanel?.track('Paywall show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
        'Test version': settingsBloc.state.abTest,
        'Screen link': settingsBloc.state.abTest == 'A'
            ? subscriptionALink
            : subscriptionBLink
      });
    });
    on<SubScreenLimShow>((event, emit) {
      _mixpanel?.track('Subscription screen show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
      });
    });
    on<BundleScreenLimShow>((event, emit) {
      _mixpanel?.track('Bundle screen from settings show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
      });
    });
    on<BundleScreenLim1Show>((event, emit) {
      _mixpanel?.track('Bundle screen from onboarding show', properties: {
        'Trigger': event.trigger,
        "Screen": event.screen,
      });
    });
    on<ActivateSubscription>((event, emit) {
      _mixpanel?.track('Activate subscription', properties: {
        'Subscription': event.plan,
        'Test version': settingsBloc.state.abTest,
        'Screen link': settingsBloc.state.abTest == 'A'
            ? subscriptionALink
            : subscriptionBLink
      });
    });
    on<ClosePaywall>((event, emit) {
      _mixpanel?.track('Close paywall');
    });
    on<ShowInstructions>((event, emit) {
      _mixpanel?.track('Show instructions');
    });
    on<CloseInstructions>((event, emit) {
      _mixpanel?.track('Сlose instructions');
    });
    on<SelectOption>((event, emit) {
      _mixpanel?.track('Select option', properties: {'Option': event.option});
    });
    on<Summify>((event, emit) {
      _mixpanel?.track('Summify', properties: {'Option': event.option});
    });
    on<SummifyError>((event, emit) {
      _mixpanel?.track('Summify', properties: {'Option': event.option});
    });
    on<SummifySuccess>((event, emit) {
      _mixpanel?.track('Summify', properties: {'Option': event.option});
    });
    on<OpenSummary>((event, emit) {
      _mixpanel?.track('Open summary');
    });
    on<DeleteSummaryM>((event, emit) {
      _mixpanel?.track('Delete summary');
    });
    on<CopySummary>((event, emit) {
      _mixpanel?.track('Copy summary');
    });
    on<ShareSummary>((event, emit) {
      _mixpanel?.track('Share summary');
    });
    // EXTENSION
    // on<SummarizingStarted>((event, emit) {
    //   final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
    //   _mixpanel?.track('summarizing_started',
    //       properties: {'language': '??', 'resource': res});
    // });

    on<SummarizingSuccess>((event, emit) {
      _mixpanel?.track('summarizing_success', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare
      });
    });

    on<SummarizingError>((event, emit) {
      _mixpanel?.track('summarizing_error', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare,
        'error': event.error
      });
    });

    on<LimitReached>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      _mixpanel?.track('limit_reached',
          properties: {'registrated': event.registrated, 'resource': res});
    });

    on<SummaryUpgrade>((event, emit) {
      _mixpanel?.track('upgrade', properties: {
        'language': '??',
        'url': event.url,
        'from_share': event.fromShare
      });
    });

    on<ShowSummaryAgain>((event, emit) {
      _mixpanel?.track('show_summary_again', properties: {
        'language': '??',
        'url': event.url,
      });
    });

    on<SummaryScroll>((event, emit) {
      final res = event.resource.contains('youtube') ? 'YouTube' : 'web';
      _mixpanel?.track('summary_scroll',
          properties: {'language': '??', 'resource': res});
    });

    on<ReadSummary>((event, emit) {
      _mixpanel?.track('read_summary', properties: {
        'summary_type': event.type,
        'summary_url': event.url,
        'AB': event.AB
      });
    });

    on<TrackResearchSummary>((event, emit) {
      _mixpanel?.track('research_summary', properties: {
        'summary_url': event.url,
      });
    });

    on<TrackTranslateSummary>((event, emit) {
      _mixpanel?.track('translate_summary', properties: {
        'summary_url': event.url,
      });
    });

    on<RedirectToSummifyExtension>((event, emit) {
      _mixpanel?.track('open_extension_link', properties: {});
    });

    on<CopySummifyExtensionLink>((event, emit) {
      _mixpanel?.track('copy_extension_link', properties: {});
    });
    on<OpenSummifyExtensionModal>((event, emit) {
      _mixpanel?.track('open_extension_modal', properties: {});
    });
    
    // KNOWLEDGE CARDS
    on<KnowledgeCardsExtracted>((KnowledgeCardsExtracted event, emit) {
      _mixpanel?.track('knowledge_cards_extracted', properties: {
        'summary_key': event.summaryKey,
        'cards_count': event.cardsCount,
      });
    });
    
    on<KnowledgeCardsExtractionError>((event, emit) {
      _mixpanel?.track('knowledge_cards_extraction_error', properties: {
        'summary_key': event.summaryKey,
        'error': event.error,
      });
    });
    
    on<KnowledgeCardSaved>((event, emit) {
      _mixpanel?.track('knowledge_card_saved', properties: {
        'summary_key': event.summaryKey,
        'card_id': event.cardId,
      });
    });
    
    on<KnowledgeCardUnsaved>((event, emit) {
      _mixpanel?.track('knowledge_card_unsaved', properties: {
        'summary_key': event.summaryKey,
        'card_id': event.cardId,
      });
    });
    
    on<KnowledgeCardsUnsupportedDevice>((event, emit) {
      _mixpanel?.track('knowledge_cards_unsupported_device', properties: {
        'summary_key': event.summaryKey,
      });
    });

    on<KnowledgeCardsTabOpen>((event, emit) {
      _mixpanel?.track('knowledge_cards_tab_open', properties: {
        'summary_key': event.summaryKey,
      });
    });
    on<KnowledgeCardOpen>((event, emit) {
      _mixpanel?.track('knowledge_card_open', properties: {
        'card_id': event.cardId,
        'summary_key': event.summaryKey,
      });
    });
    on<KnowledgeCardVoiceCheckOpen>((event, emit) {
      _mixpanel?.track('knowledge_card_voice_check_open', properties: {
        'card_id': event.cardId,
        'summary_key': event.summaryKey,
      });
    });
    on<KnowledgeCardVoiceCheckSent>((event, emit) {
      _mixpanel?.track('knowledge_card_voice_check_sent', properties: {
        'card_id': event.cardId,
        'summary_key': event.summaryKey,
        if (event.accuracy != null) 'accuracy': event.accuracy,
      });
    });
    on<KnowledgeCardsRegenerateRequested>((event, emit) {
      _mixpanel?.track('knowledge_cards_regenerate_requested', properties: {
        'summary_key': event.summaryKey,
      });
    });

    // SAVED CARDS SCREEN
    on<SavedCardsScreenOpen>((event, emit) {
      _mixpanel?.track('saved_cards_screen_open', properties: {});
    });
    on<SavedCardView>((event, emit) {
      _mixpanel?.track('saved_card_view', properties: {
        'card_id': event.cardId,
        if (event.summaryKey != null) 'summary_key': event.summaryKey!,
      });
    });
    on<SavedCardRemoved>((event, emit) {
      _mixpanel?.track('saved_card_removed', properties: {
        'card_id': event.cardId,
        if (event.summaryKey != null) 'summary_key': event.summaryKey!,
      });
    });

    // QUIZ
    on<QuizTabOpen>((event, emit) {
      _mixpanel?.track('quiz_tab_open', properties: {'document_key': event.documentKey});
    });
    on<QuizStarted>((event, emit) {
      _mixpanel?.track('quiz_started', properties: {
        'document_key': event.documentKey,
        'questions_count': event.questionsCount,
      });
    });
    on<TrackQuizAnswer>((event, emit) {
      _mixpanel?.track('quiz_answer', properties: {
        'document_key': event.documentKey,
        'correct': event.correct,
      });
    });
    on<QuizCompleted>((event, emit) {
      _mixpanel?.track('quiz_completed', properties: {
        'document_key': event.documentKey,
        'score_percent': event.scorePercent,
        'correct_count': event.correctCount,
        'total': event.total,
      });
    });
    on<QuizRetake>((event, emit) {
      _mixpanel?.track('quiz_retake', properties: {'document_key': event.documentKey});
    });
    on<QuizRegenerateRequested>((event, emit) {
      _mixpanel?.track('quiz_regenerate_requested', properties: {
        'document_key': event.documentKey,
      });
    });
  }
}
