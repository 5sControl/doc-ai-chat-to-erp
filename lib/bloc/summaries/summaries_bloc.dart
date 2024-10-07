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
    title: 'Summify',
    imageUrl: Assets.placeholderLogo.path,
  ),
  summaryOrigin: SummaryOrigin.url,
  shortSummary: const Summary(
    summaryText:
        'Summify: \nYour AI-powered summarization solution. Instantly distill lengthy content into concise summaries with accuracy and efficiency, enhancing productivity and comprehension.',
  ),
  longSummary: const Summary(
      summaryText:
          "What should you know about Summify?\nIn today's fast-paced world, where information overload is a common concern, the ability to quickly grasp the essence of a piece of content is invaluable. Enter Summify, a revolutionary mobile application designed to simplify and enhance the way we consume and share information.\nSummify is more than just a summarization tool; it's a comprehensive solution that offers a myriad of features to cater to diverse user needs. Let's delve into the intricacies of Summify's core functionalities:/n1. Share and Summarize from Any Resource:\nSummify's intuitive interface allows users to share content from any online resource, including webpages, articles, and blog posts. Simply copy the URL of the desired content and paste it into Summify."),
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
            'https://elang.app/en': initialSummary,
          },
          ratedSummaries: const {
            'https://elang.app/en'
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
