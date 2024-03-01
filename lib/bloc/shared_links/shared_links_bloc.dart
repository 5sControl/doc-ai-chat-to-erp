// import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../models/models.dart';

part 'shared_links_event.dart';
part 'shared_links_state.dart';
part 'shared_links_bloc.g.dart';

class SharedLinksBloc extends HydratedBloc<SharedLinksEvent, SharedLinksState> {
  // static var textCounter = 1;
  SharedLinksBloc() : super(const SharedLinksState(savedLinks: {}, textCounter: 1)) {
    final dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );

    on<SaveSharedLink>((event, emit) async {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.addAll({
        event.sharedLink: SummaryData(
            status: SummaryStatus.Loading, summary: null, date: DateTime.now())
      });
      emit(state.copyWith(savedLinks: summaryMap));
      final response = await dio.post(
        'https://largely-whole-horse.ngrok-free.app/fastapi/application_by_summarize/',
        data: {
          'url': event.sharedLink,
          'context': '',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final summary = Summary.fromJson(response.data);
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        final previewData = await getPreviewData(event.sharedLink);
        summaryMap.addAll({
          event.sharedLink: SummaryData(
              status: SummaryStatus.Complete,
              summary: summary.summary,
              date: DateTime.now(),
              title: previewData.title,
              description: previewData.description,
              imageUrl: previewData.image?.url)
        });
        emit(state.copyWith(savedLinks: summaryMap));
      } else if (response.statusCode == 500 | 502) {
        print('error');
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          event.sharedLink: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(savedLinks: summaryMap));
      }
    });

    on<SaveText>((event, emit) async {
      final index = state.textCounter;
      final title = "My text ($index)";
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.addAll({
        title: SummaryData(
            status: SummaryStatus.Loading, summary: null, date: DateTime.now())
      });
      emit(state.copyWith(savedLinks: summaryMap));
      final response = await dio.post(
        'https://largely-whole-horse.ngrok-free.app/fastapi/application_by_summarize/',
        data: {
          'url': '',
          'context': event.text,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final summary = Summary.fromJson(response.data);
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          title: SummaryData(
              status: SummaryStatus.Complete,
              date: DateTime.now(),
              summary: summary.summary)
        });
        emit(state.copyWith(savedLinks: summaryMap));
      } else if (response.statusCode == 500 | 502) {
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          title: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(savedLinks: summaryMap));
      }
    });

    on<DeleteSharedLink>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.remove(event.sharedLink);
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
