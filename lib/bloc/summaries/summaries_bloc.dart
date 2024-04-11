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

const String initialSummaryText = "What should you know about Summify?"
    "\n\nIn today's fast-paced world, where information overload is a common concern, the ability to quickly grasp the essence of a piece of content is invaluable. Enter Summify, a revolutionary mobile application designed to simplify and enhance the way we consume and share information. "
    "\n\nSummify is more than just a summarization tool; it's a comprehensive solution that offers a myriad of features to cater to diverse user needs. Let's delve into the intricacies of Summify's core functionalities: "
    "\n\n1. Share and Summarize from Any Resource:"
    "\nSummify's intuitive interface allows users to share content from any online resource, including webpages, articles, and blog posts. Simply copy the URL of the desired content and paste it into Summify. The app will process the information, condensing it into a succinct summary that captures the key points and main ideas. "
    "\n\n2. Summarize via URL: "
    "\nHave a long article or a complex webpage you need to understand quickly? Summify's URL summarization feature comes to the rescue. Just paste the URL of the content into Summify, and the app will generate a concise summary, making it easier for you to grasp the essential details without having to read through the entire text. "
    "\n\n3. Summarize Uploaded Documents: "
    "\nSummify supports document summarization, making it an invaluable tool for professionals, researchers, and students. Users can upload documents in various formats, including PDF, DOCX, or TXT. Summify processes the uploaded document, distilling it into a condensed summary that retains the original document's core message and key insights. "
    "\n\n4. Summarize Custom Text: "
    "\nNeed a summary of a specific piece of text or a document you've written? Summify's text summarization feature has you covered. Simply type or paste your custom text into the app, and Summify will generate a summarized version, allowing you to quickly get to the heart of the matter. "
    "\n\n5. Advanced Summarization Algorithms: "
    "\nSummify's summarization algorithms are sophisticated and meticulously designed to ensure that the summaries provided are coherent, informative, and relevant to the original content. By analyzing the context, structure, and semantic meaning of the text, Summify delivers summaries that are accurate and comprehensive. "
    "\n\n6. Save Time and Focus on What Matters: "
    "\nWith Summify, you can save valuable time by getting the gist of a piece of content without having to read through lengthy paragraphs. Whether you're a busy professional trying to stay updated on industry trends, a student looking for key information for a research project, or simply someone who wants to consume content more efficiently, Summify is the ultimate solution. "
    "\n\nIn conclusion, Summify is more than just a summarization tool; it's a versatile and indispensable companion that enhances the way we interact with information. Whether you're looking to quickly understand a complex article, share condensed versions of content with your colleagues, or streamline your own written materials, Summify is your go-to app. Experience the convenience and efficiency of content condensation with Summify – your ultimate content consumption and sharing companion!";

final initialSummary = SummaryData(
    status: SummaryStatus.Complete,
    date: DateTime.now(),
    title: 'Summify',
    imageUrl: Assets.placeholderLogo.path,
    error: null,
    summary: initialSummaryText,
    formattedDate: 'What should you know about Summify?');

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
        add(const SetDailyLimit(dailyLimit: 3));
      }
    });

    on<GetSummaryFromUrl>(
      (event, emit) async {
        if (state.summaries[event.summaryUrl]?.status !=
            SummaryStatus.Loading) {
          await startSummaryLoading(event.summaryUrl, emit);
          await loadSummaryPreview(event.summaryUrl, emit);
          await loadSummaryFromUrl(event.summaryUrl, event.fromShare, emit);
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromText>(
      (event, emit) async {
        final index = state.textCounter;
        final title = "My text ($index)";

        if (state.summaries[title]?.status != SummaryStatus.Loading) {
          await startSummaryLoading(title, emit);
          await loadSummaryFromText(
              summaryTitle: title, text: event.text, emit: emit);
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromFile>(
      (event, emit) async {
        if (state.summaries[event.fileName]?.status != SummaryStatus.Loading) {
          await startSummaryLoading(event.fileName, emit);
          await loadSummaryFromFile(
              fileName: event.fileName,
              filePath: event.filePath,
              fromShare: event.fromShare,
              emit: emit);
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<DeleteSummary>((event, emit) {
      deleteSummary(event.summaryUrl, emit);
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
      final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
      // summaryMap.forEach((key, value) {
      //   if (value.status == SummaryStatus.Loading) {
      summaryMap.update(event.sharedLink, (summary) {
        return summary.copyWith(
            status: SummaryStatus.Error, summary: null, error: 'Stopped');
      });
      // }
      // });
      emit(state.copyWith(summaries: summaryMap));
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
      String summaryUrl, Emitter<SummariesState> emit) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
    final String formattedDate = formatter.format(DateTime.now());
    summaryMap.addAll({
      summaryUrl: SummaryData(
          status: SummaryStatus.Loading,
          date: DateTime.now(),
          title: summaryUrl,
          imageUrl: Assets.placeholderLogo.path,
          formattedDate: formattedDate,
          summary: null,
          error: null)
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryPreview(
      String summaryUrl, Emitter<SummariesState> emit) async {
    final previewData = await getPreviewData(summaryUrl);
    final summaryData = state.summaries[summaryUrl]?.copyWith(
      imageUrl: previewData.image?.url,
      title: previewData.title,
    );
    final Map<String, SummaryData> summariesMap = Map.from(state.summaries);

    summariesMap.update(summaryUrl, (value) => summaryData!);
    print('emit preview');
    emit(state.copyWith(summaries: summariesMap));
  }

  Future<void> loadSummaryFromUrl(
      String summaryUrl, bool fromShare, Emitter<SummariesState> emit) async {
    if (fromShare) {
      mixpanelBloc.add(SummarizingStarted(resource: summaryUrl));
    } else {
      mixpanelBloc.add(const Summify(option: 'link'));
    }

    final summary =
        await summaryRepository.getSummaryFromLink(summaryLink: summaryUrl);
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final summaryData = state.summaries[summaryUrl];
    summaryMap.update(summaryUrl, (_) {
      if (summary is Summary) {
        incrementDailySummaryCount(emit);

        if (fromShare) {
          mixpanelBloc.add(SummarizingSuccess(resource: summaryUrl));
        } else {
          mixpanelBloc.add(const SummifySuccess(option: 'link'));
        }

        return summaryData!.copyWith(
            summary: summary.summary,
            status: SummaryStatus.Complete,
            error: null);
      } else if (summary is Exception) {
        mixpanelBloc.add(const SummifyError(option: 'link'));

        return summaryData!.copyWith(
            error: summary.toString().substring(11),
            summary: null,
            status: SummaryStatus.Error);
      } else {
        mixpanelBloc.add(const SummifyError(option: 'link'));
        return summaryData!
            .copyWith(error: 'Loading error', status: SummaryStatus.Error);
      }
    });

    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryFromText(
      {required String summaryTitle,
      required String text,
      required Emitter<SummariesState> emit}) async {
    final summary =
        await summaryRepository.getSummaryFromText(textToSummify: text);
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final summaryData = state.summaries[summaryTitle];

    summaryMap.update(summaryTitle, (_) {
      if (summary is Summary) {
        incrementDailySummaryCount(emit);
        emit(state.copyWith(textCounter: state.textCounter + 1));
        mixpanelBloc.add(const SummifySuccess(option: 'text'));
        return summaryData!.copyWith(
            summary: summary.summary,
            status: SummaryStatus.Complete,
            error: null);
      } else if (summary is Exception) {
        mixpanelBloc.add(const SummifyError(option: 'text'));
        return summaryData!.copyWith(
            error: summary.toString().substring(11),
            summary: null,
            status: SummaryStatus.Error);
      } else {
        mixpanelBloc.add(const SummifyError(option: 'text'));
        return summaryData!
            .copyWith(error: 'Loading error', status: SummaryStatus.Error);
      }
    });
    mixpanelBloc.add(const Summify(option: 'text'));
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryFromFile(
      {required String fileName,
      required String filePath,
      required bool fromShare,
      required Emitter<SummariesState> emit}) async {
    if (fromShare) {
      mixpanelBloc.add(SummarizingStarted(resource: fileName));
    } else {
      mixpanelBloc.add(const Summify(option: 'file'));
    }

    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final summaryData = state.summaries[fileName];
    final summary = await summaryRepository.getSummaryFromFile(
        fileName: fileName, filePath: filePath);
    summaryMap.update(fileName, (_) {
      if (summary is Summary) {
        incrementDailySummaryCount(emit);
        mixpanelBloc.add(const SummifySuccess(option: 'file'));
        return summaryData!.copyWith(
            summary: summary.summary,
            status: SummaryStatus.Complete,
            error: null);
      } else if (summary is Exception) {
        mixpanelBloc.add(const SummifyError(option: 'file'));
        return summaryData!.copyWith(
            error: summary.toString().substring(11),
            summary: null,
            status: SummaryStatus.Error);
      } else {
        mixpanelBloc.add(const SummifyError(option: 'file'));
        return summaryData!
            .copyWith(error: 'Loading error', status: SummaryStatus.Error);
      }
    });
    mixpanelBloc.add(const Summify(option: 'file'));
    emit(state.copyWith(summaries: summaryMap));
  }

  void deleteSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.remove(summaryUrl);
    mixpanelBloc.add(const DeleteSummaryM());
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> rateSummary(
      RateSummary event, Emitter<SummariesState> emit) async {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(event.summaryUrl);

    await summaryRepository.sendSummaryRate(
        summaryLink: event.summaryUrl,
        summary: state.summaries[event.summaryUrl]?.summary ?? '',
        rate: event.rate,
        device: event.device,
        comment: event.comment);

    emit(state.copyWith(ratedSummaries: ratedSummaries));
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

  // Future<void> loadSummaryFromText(
  //     LoadSummaryFromText event, Emitter<SummariesState> emit) async {
  //   final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
  //   final summaryData = state.summaries[event.summaryTitle];
  //   final summary =
  //       await summaryRepository.getSummaryFromText(textToSummify: event.text);
  //   summaryMap.update(event.summaryTitle, (_) {
  //     if (summary is Summary) {
  //       return summaryData!.copyWith(
  //           summary: summary.summary,
  //           status: SummaryStatus.Complete,
  //           error: null);
  //     } else if (summary is Exception) {
  //       return summaryData!.copyWith(
  //           error: summary.toString().substring(11),
  //           summary: null,
  //           status: SummaryStatus.Error);
  //     } else {
  //       return summaryData!
  //           .copyWith(error: 'Loading error', status: SummaryStatus.Error);
  //     }
  //   });
  //   emit(state.copyWith(summaries: summaryMap));
  // }
}
