import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';
part 'summaries_bloc.g.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SummariesBloc extends HydratedBloc<SummariesEvent, SummariesState> {
  final SummaryRepository summaryRepository = SummaryRepository();
  SummariesBloc() : super(const SummariesState(summaries: {})) {
    on<GetSummaryFromSharedUrl>(
      getSummaryFromSharedUrl,
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromSharedText>(
      getSummaryFromSharedText,
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromSharedFile>(
      getSummaryFromSharedFile,
      transformer: throttleDroppable(throttleDuration),
    );

    on<LoadSummaryPreview>(
      loadSummaryPreview,
      transformer: throttleDroppable(throttleDuration),
    );
    on<LoadSummaryFromUrl>(
      loadSummaryFromUrl,
      transformer: throttleDroppable(throttleDuration),
    );
    on<StartSummaryLoading>(startSummaryLoading);
  }

  @override
  SummariesState? fromJson(Map<String, dynamic> json) {
    return SummariesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SummariesState state) {
    return state.toJson();
  }

  Future<void> getSummaryFromSharedUrl(
    GetSummaryFromSharedUrl event,
    Emitter<SummariesState> emit,
  ) async {
    add(StartSummaryLoading(summaryUrl: event.summaryUrl));
    add(LoadSummaryPreview(summaryUrl: event.summaryUrl));
    add(LoadSummaryFromUrl(summaryUrl: event.summaryUrl));
  }

  Future<void> getSummaryFromSharedText(
    GetSummaryFromSharedText event,
    Emitter<SummariesState> emit,
  ) async {
    final summaryTitle = 'My text';
    add(StartSummaryLoading(summaryUrl: summaryTitle));
    add(LoadSummaryFromText(summaryTitle: summaryTitle, text: event.text));
  }

  Future<void> getSummaryFromSharedFile(
    GetSummaryFromSharedFile event,
    Emitter<SummariesState> emit,
  ) async {
    final summaryTitle = event.summaryFile.path.split('/').last;
    add(StartSummaryLoading(summaryUrl: summaryTitle));
    add(LoadSummaryFromFile(
        fileName: summaryTitle, filePath: event.summaryFile.path));
  }

  Future<void> startSummaryLoading(
      StartSummaryLoading event, Emitter<SummariesState> emit) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.addAll({
      event.summaryUrl: SummaryData(
          status: SummaryStatus.Loading,
          date: DateTime.now(),
          title: event.summaryUrl,
          imageUrl: Assets.placeholderLogo.path,
          summary: null,
          error: null)
    });
    add(LoadSummaryPreview(summaryUrl: event.summaryUrl));
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryPreview(
      LoadSummaryPreview event, Emitter<SummariesState> emit) async {
    final previewData = await getPreviewData(event.summaryUrl);
    final summaryData = state.summaries[event.summaryUrl]?.copyWith(
      imageUrl: previewData.image?.url,
      title: previewData.title,
    );
    final Map<String, SummaryData> summariesMap = Map.from(state.summaries);

    summariesMap.update(event.summaryUrl, (value) => summaryData!);
    emit(state.copyWith(summaries: summariesMap));
  }

  Future<void> loadSummaryFromUrl(
      LoadSummaryFromUrl event, Emitter<SummariesState> emit) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final summaryData = state.summaries[event.summaryUrl];
    final summary = await summaryRepository.getSummaryFromLink(
        summaryLink: event.summaryUrl);
    summaryMap.update(event.summaryUrl, (_) {
      if (summary is Summary) {
        return summaryData!.copyWith(
            summary: summary.summary,
            status: SummaryStatus.Complete,
            error: null);
      } else if (summary is Exception) {
        return summaryData!.copyWith(
            error: summary.toString().substring(11),
            summary: null,
            status: SummaryStatus.Error);
      } else {
        return summaryData!
            .copyWith(error: 'Loading error', status: SummaryStatus.Error);
      }
    });
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> loadSummaryFromText(
      LoadSummaryFromText event, Emitter<SummariesState> emit) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    final summaryData = state.summaries[event.summaryTitle];
    final summary =
        await summaryRepository.getSummaryFromText(textToSummify: event.text);
    summaryMap.update(event.summaryTitle, (_) {
      if (summary is Summary) {
        return summaryData!.copyWith(
            summary: summary.summary,
            status: SummaryStatus.Complete,
            error: null);
      } else if (summary is Exception) {
        return summaryData!.copyWith(
            error: summary.toString().substring(11),
            summary: null,
            status: SummaryStatus.Error);
      } else {
        return summaryData!
            .copyWith(error: 'Loading error', status: SummaryStatus.Error);
      }
    });
    emit(state.copyWith(summaries: summaryMap));
  }
}
