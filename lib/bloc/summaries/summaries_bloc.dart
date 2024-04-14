import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';

import '../subscription/subscription_bloc.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';
part 'summaries_bloc.g.dart';

final initialSummary = SummaryData(
  status: SummaryStatus.complete,
  date: DateTime.now(),
  summaryPreview: SummaryPreview(
    title: 'Summify',
    imageUrl: Assets.placeholderLogo.path,
  ),
  summary: const Summary(
      summaryShort:
          'Summify: \nYour AI-powered summarization solution. Instantly distill lengthy content into concise summaries with accuracy and efficiency, enhancing productivity and comprehension.',
      summaryLong:
          "What should you know about Summify?\nIn today's fast-paced world, where information overload is a common concern, the ability to quickly grasp the essence of a piece of content is invaluable. Enter Summify, a revolutionary mobile application designed to simplify and enhance the way we consume and share information.\nSummify is more than just a summarization tool; it's a comprehensive solution that offers a myriad of features to cater to diverse user needs. Let's delve into the intricacies of Summify's core functionalities:/n1. Share and Summarize from Any Resource:\nSummify's intuitive interface allows users to share content from any online resource, including webpages, articles, and blog posts. Simply copy the URL of the desired content and paste it into Summify."),
  summaryOrigin: SummaryOrigin.url,
);

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return concurrent<E>().call(events.throttle(duration), mapper);
  };
}

class SummariesBloc extends HydratedBloc<SummariesEvent, SummariesState> {
  final SubscriptionBloc subscriptionBloc;
  final MixpanelBloc mixpanelBloc;
  late final StreamSubscription subscriptionBlocSubscription;

  final SummaryRepository summaryRepository = SummaryRepository();
  SummariesBloc({required this.subscriptionBloc, required this.mixpanelBloc})
      : super(SummariesState(
            summaries: {
              'https://elang-app-dev-zehqx.ondigitalocean.app/': initialSummary,
            },
            ratedSummaries: const {
              'https://elang-app-dev-zehqx.ondigitalocean.app/'
            },
            dailyLimit: 3,
            dailySummariesMap: const {},
            textCounter: 1)) {
    subscriptionBlocSubscription = subscriptionBloc.stream.listen((state) {
      if (state.subscriptionsStatus == SubscriptionsStatus.subscribed) {
        add(const SetDailyLimit(dailyLimit: 15));
      } else {
        add(const SetDailyLimit(dailyLimit: 300));
      }
    });

    on<GetSummaryFromUrl>(
      (event, emit) async {
        if (state.summaries[event.summaryUrl]?.status !=
            SummaryStatus.loading) {
          await startSummaryLoading(summaryKey: event.summaryUrl, emit: emit);
          await loadSummaryPreview(summaryKey: event.summaryUrl, emit: emit);
          await loadSummaryFromUrl(
              summaryKey: event.summaryUrl,
              fromShare: event.fromShare,
              emit: emit);
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromText>(
      (event, emit) async {
        final index = state.textCounter;
        final title = "My text ($index)";

        // if (state.summaries[title]?.status != SummaryStatus.Loading) {
        //   await startSummaryLoading(title, emit);
        //   await loadSummaryFromText(
        //       summaryTitle: title, text: event.text, emit: emit);
        // }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromFile>(
      (event, emit) async {
        if (state.summaries[event.fileName]?.status != SummaryStatus.loading) {
          // await startSummaryLoading(event.fileName, emit);
          // await loadSummaryFromFile(
          //     fileName: event.fileName,
          //     filePath: event.filePath,
          //     fromShare: event.fromShare,
          //     emit: emit);
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<DeleteSummary>((event, emit) {
      deleteSummary(event.summaryUrl, emit);
      mixpanelBloc.add(const DeleteSummaryM());
    });

    on<RateSummary>((event, emit) async {
      await rateSummary(event, emit);
    });

    on<SkipRateSummary>((event, emit) {
      skipRateSummary(event.summaryUrl, emit);
    });

    on<SetDailyLimit>((event, emit) {
      emit(state.copyWith(dailyLimit: event.dailyLimit));
    });

    on<InitDailySummariesCount>((event, emit) {
      final DateFormat formatter = DateFormat('MM.dd.yy');
      final thisDay = formatter.format(event.thisDay);
      final Map<String, int> daysMap = Map.from(state.dailySummariesMap);
      if (!state.dailySummariesMap.containsKey(thisDay)) {
        daysMap.addAll({thisDay: 0});
        emit(state.copyWith(dailySummariesMap: daysMap));
      }
    });

    on<CancelRequest>((event, emit) {
      // final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
      // // summaryMap.forEach((key, value) {
      // //   if (value.status == SummaryStatus.Loading) {
      // summaryMap.update(event.sharedLink, (summary) {
      //   return summary.copyWith(
      //       status: SummaryStatus.error, summary: Summary(),);
      // });
      // // }
      // // });
      // emit(state.copyWith(summaries: summaryMap));
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

  Future<void> startSummaryLoading(
      {required String summaryKey,
      required Emitter<SummariesState> emit}) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.addAll({
      summaryKey: SummaryData(
          status: SummaryStatus.loading,
          date: DateTime.now(),
          summary: const Summary(),
          summaryPreview: SummaryPreview(
            imageUrl: Assets.placeholderLogo.path,
          ),
          summaryOrigin: SummaryOrigin.url)
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryPreview(
      {required String summaryKey,
      required Emitter<SummariesState> emit}) async {
    final previewData = await getPreviewData(summaryKey);
    final summaryData = state.summaries[summaryKey]?.copyWith(
        summaryPreview: SummaryPreview(
            imageUrl: previewData.image?.url, title: previewData.title));
    final Map<String, SummaryData> summariesMap = Map.from(state.summaries);
    summariesMap.update(summaryKey, (value) => summaryData!);
    emit(state.copyWith(summaries: summariesMap));
  }

  Future<void> loadSummaryFromUrl(
      {required String summaryKey,
      required bool fromShare,
      required Emitter<SummariesState> emit}) async {
    final shortSummaryResponse = await summaryRepository.getSummaryFromLink(
        summaryLink: summaryKey, summaryType: SummaryType.long);
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.update(summaryKey, (summaryData) {
      if (shortSummaryResponse is Summary) {
        incrementDailySummaryCount(emit);
        return summaryData.copyWith(
            summary: shortSummaryResponse, status: SummaryStatus.complete);
      } else if (shortSummaryResponse is Exception) {
        return summaryData;
      } else {
        return summaryData;
      }
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryFromText(
      {required String summaryTitle,
      required String text,
      required Emitter<SummariesState> emit}) async {
    // final summary =
    //     await summaryRepository.getSummaryFromText(textToSummify: text);
    // final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    // final summaryData = state.summaries[summaryTitle];
    //
    // summaryMap.update(summaryTitle, (_) {
    //   if (summary is Summary) {
    //     incrementDailySummaryCount(emit);
    //     emit(state.copyWith(textCounter: state.textCounter + 1));
    //     mixpanelBloc.add(SummifySuccess(option: 'text', url: summaryTitle));
    //     return summaryData!.copyWith(
    //         summary: summary.summary,
    //         status: SummaryStatus.Complete,
    //         error: null);
    //   } else if (summary is Exception) {
    //     mixpanelBloc.add(SummifyError(option: 'text', url: summaryTitle));
    //     return summaryData!.copyWith(
    //         error: summary.toString().substring(11),
    //         summary: null,
    //         status: SummaryStatus.Error);
    //   } else {
    //     mixpanelBloc.add(SummifyError(option: 'text', url: summaryTitle));
    //     return summaryData!
    //         .copyWith(error: 'Loading error', status: SummaryStatus.Error);
    //   }
    // });
    // mixpanelBloc.add(Summify(option: 'text', url: summaryTitle));
    // emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryFromFile(
      {required String fileName,
      required String filePath,
      required bool fromShare,
      required Emitter<SummariesState> emit}) async {
    // if (fromShare) {
    //   mixpanelBloc.add(SummarizingStarted(resource: fileName));
    // } else {
    //   mixpanelBloc.add(Summify(option: 'file', url: fileName));
    // }
    //
    // final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    // final summaryData = state.summaries[fileName];
    // final summary = await summaryRepository.getSummaryFromFile(
    //     fileName: fileName, filePath: filePath);
    // summaryMap.update(fileName, (_) {
    //   if (summary is Summary) {
    //     incrementDailySummaryCount(emit);
    //     mixpanelBloc.add(SummifySuccess(option: 'file', url: fileName));
    //     return summaryData!.copyWith(
    //         summary: summary.summary,
    //         status: SummaryStatus.Complete,
    //         error: null);
    //   } else if (summary is Exception) {
    //     mixpanelBloc.add(SummifyError(option: 'file', url: fileName));
    //     return summaryData!.copyWith(
    //         error: summary.toString().substring(11),
    //         summary: null,
    //         status: SummaryStatus.Error);
    //   } else {
    //     mixpanelBloc.add(SummifyError(option: 'file', url: fileName));
    //     return summaryData!
    //         .copyWith(error: 'Loading error', status: SummaryStatus.Error);
    //   }
    // });
    // mixpanelBloc.add(Summify(option: 'file', url: fileName));
    // emit(state.copyWith(summaries: summaryMap));
  }

  void deleteSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.remove(summaryUrl);
    mixpanelBloc.add(const DeleteSummaryM());
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> rateSummary(
      RateSummary event, Emitter<SummariesState> emit) async {
    // final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    // ratedSummaries.add(event.summaryUrl);
    //
    // await summaryRepository.sendSummaryRate(
    //     summaryLink: event.summaryUrl,
    //     summary: state.summaries[event.summaryUrl]?.summary ?? '',
    //     rate: event.rate,
    //     device: event.device,
    //     comment: event.comment);
    //
    // emit(state.copyWith(ratedSummaries: ratedSummaries));
  }

  void skipRateSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(summaryUrl);
    emit(state.copyWith(ratedSummaries: ratedSummaries));
  }

  Future<void> incrementDailySummaryCount(emit) async {
    final DateFormat dayFormatter = DateFormat('MM.dd.yy');
    final thisDay = dayFormatter.format(DateTime.now());

    final Map<String, int> newDailySummariesMap =
        Map.from(state.dailySummariesMap);
    if (newDailySummariesMap.containsKey(thisDay)) {
      newDailySummariesMap.update(thisDay, (value) => value + 1);
    } else {
      newDailySummariesMap.addAll({thisDay: 1});
    }

    emit(state.copyWith(dailySummariesMap: newDailySummariesMap));
  }
}
