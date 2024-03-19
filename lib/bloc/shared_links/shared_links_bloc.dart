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

const String initialSummaryText = "What should you know about Summify? "
    "\n\n In today's fast-paced world, where information overload is a common concern, the ability to quickly grasp the essence of a piece of content is invaluable. Enter Summify, a revolutionary mobile application designed to simplify and enhance the way we consume and share information. "
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
    opened: false,
    date: DateTime.now(),
    title: 'Summify',
    imageUrl: null,
    error: null,
    summary: initialSummaryText);

class SharedLinksBloc extends HydratedBloc<SharedLinksEvent, SharedLinksState> {
  SharedLinksBloc()
      : super(SharedLinksState(
          savedLinks: {
            'https://elang-app-dev-zehqx.ondigitalocean.app/': initialSummary,
          },
          textCounter: 1,
        )) {
    final SummaryRepository summaryRepository = SummaryRepository();

    void startSummaryLoading({required String summaryLink}) async {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.addAll({
        summaryLink: SummaryData(
            opened: false,
            status: SummaryStatus.Loading,
            summary: null,
            date: DateTime.now(),
            imageUrl: state.savedLinks[summaryLink]?.imageUrl,
            title: state.savedLinks[summaryLink]?.title,
            error: null)
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
              opened: false,
              summary: summary.summary,
              imageUrl: previewData.image?.url,
              title: previewData.title,
              error: null));
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
                opened: false,
                summary: summary.summary,
                imageUrl: value.imageUrl,
                title: value.title,
                error: null,
              ));
      emit(state.copyWith(savedLinks: summaryMap));
    }

    void setSummaryError({required String summaryLink, required String error}) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      print('ERROR SET');
      summaryMap.update(
          summaryLink,
          (value) => SummaryData(
              status: SummaryStatus.Error,
              date: value.date,
              opened: false,
              summary: null,
              imageUrl: value.imageUrl,
              title: value.title,
              error: error));
      emit(state.copyWith(savedLinks: summaryMap));
    }

    on<SaveSharedLink>((event, emit) async {
      final link = event.sharedLink.toString();
      if (state.savedLinks[link]?.status != SummaryStatus.Loading) {
        print('SAVE EVENT');
        startSummaryLoading(summaryLink: link);
        if (state.savedLinks[link]?.imageUrl == null) {
          getSummaryPreviewData(link);
        }
        final summary =
            await summaryRepository.getSummaryFromLink(summaryLink: link);
        if (summary.summary != null) {
          setSummaryComplete(summaryLink: link, summary: summary);
        } else {
          setSummaryError(
              summaryLink: link, error: summary.summaryError ?? 'Some error');
        }
      }
    });

    on<SaveText>((event, emit) async {
      final index = state.textCounter;
      final title = "My text ($index)";
      emit(state.copyWith(textCounter: index + 1));
      if (state.savedLinks[title]?.status != SummaryStatus.Loading) {
        startSummaryLoading(summaryLink: title);
        final summary = await summaryRepository.getSummaryFromText(
            textToSummify: event.text);
        if (summary.summary != null) {
          print(summary.summary);
          setSummaryComplete(summaryLink: title, summary: summary);
        } else {
          setSummaryError(
              summaryLink: title, error: summary.summaryError ?? 'Some error');
        }
      }
    });

    on<SaveFile>((event, emit) async {
      if (state.savedLinks[event.fileName]?.status != SummaryStatus.Loading) {
        startSummaryLoading(summaryLink: event.fileName);
        final summary = await summaryRepository.getSummaryFromFile(
            filePath: event.filePath, fileName: event.fileName);
        if (summary.summary != null) {
          setSummaryComplete(summaryLink: event.fileName, summary: summary);
        } else {
          setSummaryError(
              summaryLink: event.fileName, error: summary.toString());
        }
      }
    });

    on<DeleteSharedLink>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.remove(event.sharedLink);
      emit(state.copyWith(savedLinks: summaryMap));
    });

    on<SetSummaryOpened>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.update(
          event.sharedLink,
          (value) => SummaryData(
                summary: value.summary,
                status: value.status,
                date: value.date,
                opened: true,
                error: value.error,
                title: value.title,
                imageUrl: value.imageUrl,
              ));
      emit(state.copyWith(savedLinks: summaryMap));
    });

    on<CancelRequest>((event, emit) {
      print('CancelRequest');
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.forEach((key, value) {
        if (value.status == SummaryStatus.Loading) {
          summaryMap.addAll({
            key: SummaryData(
                status: SummaryStatus.Error,
                date: value.date,
                opened: value.opened,
                imageUrl: value.imageUrl,
                title: value.title,
                error: 'stopped')
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
