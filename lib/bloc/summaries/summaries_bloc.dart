import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../services/summaryApi.dart';
import '../../services/demo_data_initializer.dart';
import 'package:json_annotation/json_annotation.dart';

import '../subscriptions/subscriptions_bloc.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';
part 'summaries_bloc.g.dart';

const throttleDuration = Duration(milliseconds: 100);

/// Free tier: 1 summary per day (resets at midnight, policy A: blocked stay blocked).
const int freeDailyLimit = 1;

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
      : super(const SummariesState(
          summaries: {},
          ratedSummaries: {},
          defaultSummaryType: SummaryType.short,
          textCounter: 1,
          freeSummariesUsedToday: 0,
          lastFreeSummaryDate: '',
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
        final today = _todayDateString();
        final usedToday = _usedTodayEffective(state);
        if (state.lastFreeSummaryDate != today) {
          emit(state.copyWith(
            freeSummariesUsedToday: 1,
            lastFreeSummaryDate: today,
          ));
        } else {
          emit(state.copyWith(
            freeSummariesUsedToday: usedToday + 1,
          ));
        }
      },
    );

    on<CancelRequest>((event, emit) {
      // Implement cancel request logic if needed
    });

    on<InitializeDemo>((event, emit) {
      _initializeDemoData(emit);
    });

    // Initialize demo data after state is loaded from storage
    add(const InitializeDemo());
  }

  @override
  SummariesState? fromJson(Map<String, dynamic> json) {
    // Migrate old format (freeSummaries) to daily limit format
    if (json.containsKey('freeSummaries') &&
        !json.containsKey('freeSummariesUsedToday')) {
      final migrated = Map<String, dynamic>.from(json)
        ..remove('freeSummaries')
        ..['freeSummariesUsedToday'] = 0
        ..['lastFreeSummaryDate'] = '';
      return SummariesState.fromJson(migrated);
    }
    return SummariesState.fromJson(json);
  }

  /// Effective count of free summaries used today (0 if we're on a new day).
  static int _usedTodayEffective(SummariesState state) {
    final today = _todayDateString();
    if (state.lastFreeSummaryDate != today) return 0;
    return state.freeSummariesUsedToday;
  }

  static String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// True if free user has already used their 1 free summary today (for UI to show paywall before creating).
  static bool isFreeDailyLimitReached(
    SummariesState state,
    SubscriptionStatus subscriptionStatus,
  ) =>
      subscriptionStatus == SubscriptionStatus.unsubscribed &&
      _usedTodayEffective(state) >= freeDailyLimit;

  @override
  Map<String, dynamic>? toJson(SummariesState state) {
    return state.toJson();
  }

  /// Initializes demo data on first app launch
  void _initializeDemoData(Emitter<SummariesState> emit) {
    // Check if demo summary already exists
    if (state.summaries.containsKey(DemoDataInitializer.demoKey)) {
      // Demo already exists, no need to initialize
      return;
    }

    // Create demo summary
    final demoSummary = DemoDataInitializer.createDemoSummary();

    // Add demo summary to state
    final updatedSummaries = Map<String, SummaryData>.from(state.summaries);
    updatedSummaries[DemoDataInitializer.demoKey] = demoSummary;

    // Add to rated summaries set
    final updatedRatedSummaries = Set<String>.from(state.ratedSummaries);
    updatedRatedSummaries.add(DemoDataInitializer.demoKey);

    // Emit updated state
    emit(
      state.copyWith(
        summaries: updatedSummaries,
        ratedSummaries: updatedRatedSummaries,
      ),
    );
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

  Future<void> _loadSummaryFromUrl({
    required String summaryKey,
    required bool fromShare,
    required Emitter<SummariesState> emit,
  }) async {
    dynamic shortSummaryResponse;
    dynamic longSummaryResponse;

    try {
      final article = await summaryRepository.getArticleByUrl(summaryKey);
      if (article == null) {
        final err = Exception('Could not fetch article');
        shortSummaryResponse = err;
        longSummaryResponse = err;
      } else {
        final summaryMap = Map<String, SummaryData>.from(state.summaries);
        summaryMap.update(summaryKey, (summaryData) {
          return summaryData.copyWith(
            summaryPreview: SummaryPreview(
              title: article.title?.isNotEmpty == true
                  ? article.title
                  : summaryKey.replaceAll('https://', ''),
              imageUrl: article.imageUrl ?? Assets.placeholderLogo.path,
            ),
            userText: article.content,
          );
        });
        emit(state.copyWith(summaries: summaryMap));

        final results = await Future.wait([
          summaryRepository.getSummaryFromText(
            textToSummify: article.content,
            summaryType: SummaryType.short,
          ),
          summaryRepository.getSummaryFromText(
            textToSummify: article.content,
            summaryType: SummaryType.long,
          ),
        ]);
        shortSummaryResponse = results[0];
        longSummaryResponse = results[1];
      }
    } catch (e) {
      shortSummaryResponse = e is Exception ? e : Exception(e.toString());
      longSummaryResponse = shortSummaryResponse;
    }

    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.update(summaryKey, (summaryData) {
      if (shortSummaryResponse is Summary && longSummaryResponse is Summary) {
        add(const IncrementFreeSummaries());
        mixpanelBloc.add(
          SummarizingSuccess(url: summaryKey, fromShare: fromShare),
        );
        return summaryData.copyWith(
          isBlocked: _usedTodayEffective(state) >= freeDailyLimit &&
                  subscriptionBloc.state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed
              ? true
              : false,
          shortSummary: shortSummaryResponse,
          shortSummaryStatus: SummaryStatus.complete,
          longSummary: longSummaryResponse,
          longSummaryStatus: SummaryStatus.complete,
        );
      } else {
        final errMsg = shortSummaryResponse is Exception
            ? shortSummaryResponse.toString().replaceAll('Exception:', '')
            : shortSummaryResponse.toString();
        mixpanelBloc.add(SummarizingError(
          url: summaryKey,
          fromShare: fromShare,
          error: errMsg,
        ));
        return summaryData.copyWith(
          longSummary: Summary(summaryError: errMsg),
          shortSummary: Summary(summaryError: errMsg),
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
          isBlocked: _usedTodayEffective(state) >= freeDailyLimit &&
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
          isBlocked: _usedTodayEffective(state) >= freeDailyLimit &&
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
