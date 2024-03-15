import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:summify/services/summaryApi.dart';

import '../../models/models.dart';

part 'shared_links_event.dart';
part 'shared_links_state.dart';
part 'shared_links_bloc.g.dart';

final initialSummary = SummaryData(
    status: SummaryStatus.Complete,
    date: DateTime.now(),
    title: 'Summify',
    imageUrl: null,
    summary:
        "What should you know about Summify? \n\nIn today's fast-paced world, where information overload is a common concern, the ability to quickly grasp the essence of a piece of content is invaluable. Enter Summify, a revolutionary mobile application designed to simplify and enhance the way we consume and share information. \nSummify is more than just a summarization tool; it's a comprehensive solution that offers a myriad of features to cater to diverse user needs. Let's delve into the intricacies of Summify's core functionalities:\n\n 1. Share and Summarize from Any Resource:        Summify's intuitive interface allows users to share content from any online resource, including webpages, articles, and blog posts. Simply copy the URL of the desired content and paste it into Summify. The app will process the information, condensing it into a succinct summary that captures the key ");

class SharedLinksBloc extends HydratedBloc<SharedLinksEvent, SharedLinksState> {
  // static var textCounter = 1;
  SharedLinksBloc()
      : super(SharedLinksState(savedLinks: {
          'https://elang-app-dev-zehqx.ondigitalocean.app/': initialSummary,
        }, textCounter: 1)) {
    final SummaryRepository summaryRepository = SummaryRepository();

    void startSummaryLoading({required String summaryLink}) async {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.addAll({
        summaryLink: SummaryData(
            status: SummaryStatus.Loading,
            summary: null,
            date: DateTime.now(),
            imageUrl: state.savedLinks[summaryLink]?.imageUrl,
            title: state.savedLinks[summaryLink]?.title)
      });

      emit(state.copyWith(savedLinks: summaryMap));
    }

    void getSummaryPreviewData(String summaryLink) async {
      final previewData = await getPreviewData(summaryLink);
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.update(
          summaryLink,
          (summary) => SummaryData(
                status: SummaryStatus.Loading,
                date: summary.date,
                summary: summary.summary,
                imageUrl: previewData.image?.url,
                title: previewData.title,
              ));
      emit(state.copyWith(savedLinks: summaryMap));
    }

    void setSummaryComplete(
        {required String summaryLink, required Summary summary}) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);

      summaryMap.update(
          summaryLink,
          (value) => SummaryData(
                status: SummaryStatus.Complete,
                date: value.date,
                summary: summary.summary,
                imageUrl: value.imageUrl,
                title: value.title,
              ));
      emit(state.copyWith(savedLinks: summaryMap));
    }

    void setSummaryError({required String summaryLink}) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.update(
          summaryLink,
          (value) => SummaryData(
                status: SummaryStatus.Error,
                date: value.date,
                summary: null,
                imageUrl: value.imageUrl,
                title: value.title,
              ));
      emit(state.copyWith(savedLinks: summaryMap));
    }

    on<SaveSharedLink>(
      (event, emit) async {
        startSummaryLoading(summaryLink: event.sharedLink);
        if (state.savedLinks[event.sharedLink]?.imageUrl == null) {
          getSummaryPreviewData(event.sharedLink);
        }
        final summary = await summaryRepository.getSummaryFromLink(
            summaryLink: event.sharedLink);
        if (summary != null) {
          setSummaryComplete(summaryLink: event.sharedLink, summary: summary);
        } else {
          setSummaryError(summaryLink: event.sharedLink);
        }
      },
      // transformer: (events, mapper) {
      //   print(events);
      //   return null;
      // },
    );

    on<SaveText>((event, emit) async {
      final index = state.textCounter;
      final title = "My text ($index)";
      startSummaryLoading(summaryLink: title);
      final summary =
          await summaryRepository.getSummaryFromText(textToSummify: event.text);
      if (summary != null) {
        setSummaryComplete(summaryLink: title, summary: summary);
      } else {
        setSummaryError(summaryLink: title);
      }
      emit(state.copyWith(textCounter: index + 1));
    });

    on<SaveFile>((event, emit) async {
      startSummaryLoading(summaryLink: event.fileName);
      final summary = await summaryRepository.getSummaryFromFile(
          filePath: event.filePath, fileName: event.fileName);
      if (summary != null) {
        setSummaryComplete(summaryLink: event.fileName, summary: summary);
      } else {
        setSummaryError(summaryLink: event.fileName);
      }
    });

    on<DeleteSharedLink>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.remove(event.sharedLink);
      emit(state.copyWith(savedLinks: summaryMap));
    });

    on<CancelRequest>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.forEach((key, value) {
        if (value.status == SummaryStatus.Loading) {
          summaryMap.addAll({
            key: SummaryData(
                status: SummaryStatus.Error,
                date: value.date,
                imageUrl: value.imageUrl,
                title: value.title)
          });
        }
      });
      emit(state.copyWith(savedLinks: summaryMap));
    });
  }

  @override
  SharedLinksState fromJson(Map<String, dynamic> json) {
    return SharedLinksState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(SharedLinksState state) {
    return state.toJson();
  }
}
