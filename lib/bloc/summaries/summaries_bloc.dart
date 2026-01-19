import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';

import '../subscriptions/subscriptions_bloc.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';
part 'summaries_bloc.g.dart';

final initialSummary = SummaryData(
  shortSummaryStatus: SummaryStatus.complete,
  longSummaryStatus: SummaryStatus.complete,
  date: DateTime.now(),
  summaryPreview: SummaryPreview(
    title: 'Atomic Habits (Rephrase)',
    imageUrl: null,
  ),
  summaryOrigin: SummaryOrigin.text,
  shortSummary: const Summary(
    summaryText:
        'Summary:\nAtomic Habits Core Concepts\n\nTiny, incremental changes compound into remarkable results over time. The key is building identity-based systems, not focusing on goals.\n\nKey Points:\nThe Four Laws of Behavior Change:\n1. Make it Obvious - Use habit stacking and environmental design\n2. Make it Attractive - Use temptation bundling and positive reframing\n3. Make it Easy - Follow the Two-Minute Rule, reduce friction\n4. Make it Satisfying - Track progress, reward immediately\n\nKey Principles:\n- Focus on systems, not goals\n- Every action is a vote for your identity\n- Results lag behind habits (Plateau of Latent Potential)\n- You don\'t rise to your goals, you fall to your systems\n\nIn-depth Analysis:\nThe Two-Minute Rule: Downscale any habit to take two minutes or less. "Go for a run" becomes "put on running shoes." Master showing up first.\n\nAdditional Context:\nWhat is rewarded is repeated. What is punished is avoided.',
  ),
  longSummary: const Summary(
      summaryText:
          "Summary:\nCore Idea:\nTiny, incremental changes (atomic habits) compound into remarkable results over time. Focus not on goals, but on building identity-based systems.\n\nKey Points:\nThe Four Laws of Behavior Change (The Framework for Good Habits):\n\nTo build a good habit, make it:\n\n1. Obvious (Cue): Make the cue for your habit visible.\n- Strategy: Use \"Habit Stacking\": \"After [CURRENT HABIT], I will [NEW HABIT].\" (e.g., \"After I pour my morning coffee, I will write one sentence in my journal.\")\n- Strategy: Design your environment. Place visual cues where you\'ll see them (e.g., put your running shoes by the door).\n\n2. Attractive (Craving): Make the habit appealing.\n- Strategy: Use \"Temptation Bundling.\" Pair something you want to do with something you need to do. (e.g., \"Only listen to my favorite podcast while at the gym.\")\n- Strategy: Reframe your mindset. Focus on the benefits and positive feelings the habit will bring.\n\n3. Easy (Response): Reduce friction. Make the habit simple to start.\n- Strategy: The Two-Minute Rule. Downscale any new habit to take two minutes or less to do. (\"Go for a run\" becomes \"put on running shoes.\") Master the art of showing up.\n- Strategy: Optimize your environment to make the easiest choice the right one (e.g., prepare a healthy lunch the night before).\n\n4. Satisfying (Reward): Make it immediately rewarding.\n- Strategy: Use immediate reinforcement. Track your habit on a calendar (don\'t break the chain!) or give yourself a small, healthy reward.\n- The Cardinal Rule: What is rewarded is repeated. What is punished is avoided.\n\nIn-depth Analysis:\nKey Supporting Concepts:\n- Forget goals, focus on systems. Goals are about results you want; systems are about the processes that lead to those results. You don\'t rise to the level of your goals, you fall to the level of your systems.\n- Identity change is the North Star. The ultimate form of intrinsic motivation is when a habit becomes part of your identity. Shift from \"I want to run\" to \"I am a runner.\" Every small action is a vote for that new identity.\n- The Plateau of Latent Potential (The Valley of Disappointment). Results often lag behind habits. Trust the compounding process. Breakthroughs happen after pushing through this plateau.\n\nAdditional Context:\nIn a Nutshell:\nTo build a good habit, use the Four Laws: Make it obvious, attractive, easy, and satisfying. Start extremely small, focus on consistent repetition, and design your environment to make the right behaviors effortless. Your habits shape your identity, and your identity shapes your habits."),
);

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return concurrent<E>().call(events.throttle(duration), mapper);
  };
}

// summaries_bloc.dart

class SummariesBloc extends HydratedBloc<SummariesEvent, SummariesState> {
  final SubscriptionsBloc subscriptionBloc;
  final MixpanelBloc mixpanelBloc;
  late final StreamSubscription subscriptionBlocSubscription;
  final SummaryRepository summaryRepository = SummaryRepository();

  SummariesBloc({required this.subscriptionBloc, required this.mixpanelBloc})
      : super(SummariesState(
          summaries: {
            'Atomic Habits': initialSummary,
          },
          ratedSummaries: const {
            'Atomic Habits'
          },
          defaultSummaryType: SummaryType.short,
          textCounter: 1,
          freeSummaries: 0,
        )) {
    subscriptionBlocSubscription = subscriptionBloc.stream.listen((state) {
      if (state.subscriptionStatus == SubscriptionStatus.subscribed) {
        add(const UnlockHiddenSummaries());
      }
    });

    on<GetSummaryFromUrl>(
      (event, emit) async {
        await _startSummaryLoading(
          summaryTitle: event.summaryUrl,
          summaryKey: event.summaryUrl,
          emit: emit,
          summaryOrigin: SummaryOrigin.url,
        );
        await _loadSummaryPreview(summaryKey: event.summaryUrl, emit: emit);
        await _loadSummaryFromUrl(
          summaryKey: event.summaryUrl,
          fromShare: event.fromShare,
          emit: emit,
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromText>(
      (event, emit) async {
        final index = state.textCounter;
        final title = "My text ($index)";

        await _startSummaryLoading(
          summaryTitle: title,
          summaryKey: title,
          emit: emit,
          summaryOrigin: SummaryOrigin.text,
        );
        await _loadSummaryFromText(
          text: event.text,
          summaryTitle: title,
          emit: emit,
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromFile>(
      (event, emit) async {
        if (state.summaries[event.fileName]?.shortSummaryStatus !=
            SummaryStatus.loading) {
          await _startSummaryLoading(
            summaryTitle: event.fileName,
            summaryKey: event.fileName,
            emit: emit,
            summaryOrigin: SummaryOrigin.file,
          );
          await _loadSummaryFromFile(
            fileName: event.fileName,
            filePath: event.filePath,
            fromShare: event.fromShare,
            emit: emit,
          );
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<DeleteSummary>((event, emit) {
      _deleteSummary(event.summaryUrl, emit);
      mixpanelBloc.add(const DeleteSummaryM());
    });

    on<RateSummary>((event, emit) async {
      await _rateSummary(event, emit);
    });

    on<SkipRateSummary>((event, emit) {
      _skipRateSummary(event.summaryUrl, emit);
    });

    on<UnlockHiddenSummaries>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
      summaryMap.updateAll(
        (key, value) {
          return value.copyWith(isBlocked: false);
        },
      );
      emit(state.copyWith(summaries: summaryMap));
    });

    on<IncrementFreeSummaries>(
      (event, emit) {
        emit(state.copyWith(freeSummaries: state.freeSummaries + 1));
      },
    );

    on<CancelRequest>((event, emit) {
      // Implement cancel request logic if needed
    });
  }

  @override
  SummariesState? fromJson(Map<String, dynamic> json) {
    return SummariesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SummariesState state) {
    return state.toJson();
  }

  Future<void> _startSummaryLoading({
    required String summaryKey,
    required String summaryTitle,
    required SummaryOrigin summaryOrigin,
    required Emitter<SummariesState> emit,
  }) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap[summaryKey] = SummaryData(
      shortSummaryStatus: SummaryStatus.loading,
      longSummaryStatus: SummaryStatus.loading,
      date: DateTime.now(),
      shortSummary: const Summary(),
      longSummary: const Summary(),
      summaryPreview: SummaryPreview(
        title: summaryTitle,
        imageUrl: Assets.placeholderLogo.path,
      ),
      summaryOrigin: summaryOrigin,
    );
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> _loadSummaryPreview({
    required String summaryKey,
    required Emitter<SummariesState> emit,
  }) async {
    final previewData = await getPreviewData(summaryKey);
    final summaryData = state.summaries[summaryKey]?.copyWith(
      summaryPreview: SummaryPreview(
        imageUrl: previewData.image?.url ?? Assets.placeholderLogo.path,
        title: previewData.title,
      ),
    );
    final Map<String, SummaryData> summariesMap = Map.from(state.summaries);
    summariesMap.update(summaryKey, (value) => summaryData!);
    emit(state.copyWith(summaries: summariesMap));
  }

  Future<void> _loadSummaryFromUrl({
    required String summaryKey,
    required bool fromShare,
    required Emitter<SummariesState> emit,
  }) async {
    final shortSummaryResponse = await summaryRepository.getSummaryFromLink(
      summaryLink: summaryKey,
      summaryType: SummaryType.short,
    );
    final longSummaryResponse = await summaryRepository.getSummaryFromLink(
      summaryLink: summaryKey,
      summaryType: SummaryType.long,
    );

    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.update(summaryKey, (summaryData) {
      if (shortSummaryResponse is Summary && longSummaryResponse is Summary) {
        add(const IncrementFreeSummaries());
        mixpanelBloc.add(
          SummarizingSuccess(url: summaryKey, fromShare: fromShare),
        );
        return summaryData.copyWith(
          isBlocked: state.freeSummaries >= 2 &&
                  subscriptionBloc.state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed
              ? true
              : false,
          shortSummary: shortSummaryResponse,
          shortSummaryStatus: SummaryStatus.complete,
          longSummary: longSummaryResponse,
          longSummaryStatus: SummaryStatus.complete,
        );
      } else if (shortSummaryResponse is Exception) {
        mixpanelBloc.add(SummarizingError(
          url: summaryKey,
          fromShare: fromShare,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      } else {
        mixpanelBloc.add(SummarizingError(
          url: summaryKey,
          fromShare: fromShare,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      }
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> _loadSummaryFromText({
    required String summaryTitle,
    required String text,
    required Emitter<SummariesState> emit,
  }) async {
    final shortSummaryResponse = await summaryRepository.getSummaryFromText(
      textToSummify: text,
      summaryType: SummaryType.short,
    );
    final longSummaryResponse = await summaryRepository.getSummaryFromText(
      textToSummify: text,
      summaryType: SummaryType.long,
    );

    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.update(summaryTitle, (summaryData) {
      if (shortSummaryResponse is Summary && longSummaryResponse is Summary) {
        mixpanelBloc.add(
          const SummarizingSuccess(url: 'from text', fromShare: false),
        );
        add(const IncrementFreeSummaries());
        return summaryData.copyWith(
          isBlocked: state.freeSummaries >= 2 &&
                  subscriptionBloc.state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed
              ? true
              : false,
          summaryOrigin: SummaryOrigin.text,
          userText: text,
          shortSummary: shortSummaryResponse,
          shortSummaryStatus: SummaryStatus.complete,
          longSummary: longSummaryResponse,
          longSummaryStatus: SummaryStatus.complete,
        );
      } else if (shortSummaryResponse is Exception) {
        mixpanelBloc.add(SummarizingError(
          url: 'from Text',
          fromShare: false,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          summaryOrigin: SummaryOrigin.text,
          userText: text,
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      } else {
        mixpanelBloc.add(SummarizingError(
          url: 'from Text',
          fromShare: false,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          summaryOrigin: SummaryOrigin.text,
          userText: text,
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      }
    });
    emit(state.copyWith(
      summaries: summaryMap,
      textCounter: state.textCounter + 1,
    ));
  }

  Future<void> _loadSummaryFromFile({
    required String fileName,
    required String filePath,
    required bool fromShare,
    required Emitter<SummariesState> emit,
  }) async {
    final shortSummaryResponse = await summaryRepository.getSummaryFromFile(
      fileName: fileName,
      filePath: filePath,
      summaryType: SummaryType.short,
    );
    final longSummaryResponse = await summaryRepository.getSummaryFromFile(
      fileName: fileName,
      filePath: filePath,
      summaryType: SummaryType.long,
    );

    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.update(fileName, (summaryData) {
      if (shortSummaryResponse is Summary && longSummaryResponse is Summary) {
        mixpanelBloc.add(
          SummarizingSuccess(url: fileName, fromShare: fromShare),
        );
        add(const IncrementFreeSummaries());
        return summaryData.copyWith(
          isBlocked: state.freeSummaries >= 2 &&
                  subscriptionBloc.state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed
              ? true
              : false,
          filePath: filePath,
          shortSummary: shortSummaryResponse,
          shortSummaryStatus: SummaryStatus.complete,
          longSummary: longSummaryResponse,
          longSummaryStatus: SummaryStatus.complete,
        );
      } else if (shortSummaryResponse is Exception) {
        mixpanelBloc.add(SummarizingError(
          url: fileName,
          fromShare: false,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          filePath: filePath,
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      } else {
        mixpanelBloc.add(SummarizingError(
          url: fileName,
          fromShare: false,
          error: shortSummaryResponse.toString().replaceAll('Exception:', ''),
        ));
        return summaryData.copyWith(
          longSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          shortSummary: Summary(
            summaryError: shortSummaryResponse
                .toString()
                .replaceAll('Exception:', ''),
          ),
          longSummaryStatus: SummaryStatus.error,
          shortSummaryStatus: SummaryStatus.error,
        );
      }
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  void _deleteSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.remove(summaryUrl);
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> _rateSummary(
      RateSummary event, Emitter<SummariesState> emit) async {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(event.summaryUrl);

    await summaryRepository.sendSummaryRate(
      summaryLink: event.summaryUrl,
      summary: state.summaries[event.summaryUrl]?.shortSummary.summaryText ??
          state.summaries[event.summaryUrl]?.longSummary.summaryText ??
          '',
      rate: event.rate,
      device: event.device,
      comment: event.comment,
    );

    emit(state.copyWith(ratedSummaries: ratedSummaries));
  }

  void _skipRateSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(summaryUrl);
    emit(state.copyWith(ratedSummaries: ratedSummaries));
  }
}
