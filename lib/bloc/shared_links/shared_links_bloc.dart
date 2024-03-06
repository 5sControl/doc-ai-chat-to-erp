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
  SharedLinksBloc()
      : super(const SharedLinksState(savedLinks: {}, textCounter: 1)) {
    const duration = Duration(seconds: 90);
    BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: duration,
        receiveTimeout: duration);
    final dio = Dio(options);
    CancelToken cancelToken = CancelToken();

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
      final previewData = await getPreviewData(event.sharedLink);
      summaryMap.addAll({
        event.sharedLink: SummaryData(
            status: SummaryStatus.Loading,
            summary: null,
            date: DateTime.now(),
            title: previewData.title,
            description: previewData.description,
            imageUrl: previewData.image?.url)
      });
      // emit(state.copyWith(savedLinks: summaryMap));
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
          cancelToken: cancelToken);
      print(response);
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
      } else {
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
          cancelToken: cancelToken);
      print(response);
      if (response.statusCode == 200) {
        final summary = Summary.fromJson(response.data);
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          title: SummaryData(
              status: SummaryStatus.Complete,
              date: DateTime.now(),
              summary: summary.summary)
        });
        emit(state.copyWith(savedLinks: summaryMap, textCounter: index + 1));
      } else {
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          title: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(savedLinks: summaryMap, textCounter: index + 1));
      }
    });

    on<SaveFile>((event, emit) async {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          event.filePath,
          filename: event.fileName,
        ),
      });
      summaryMap.addAll({
        event.fileName: SummaryData(
            status: SummaryStatus.Loading, summary: null, date: DateTime.now())
      });
      emit(state.copyWith(savedLinks: summaryMap));
      final response = await dio.post(
          'https://largely-whole-horse.ngrok-free.app/fastapi/application_by_summarize/uploadfile/',
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
          ),
          cancelToken: cancelToken,
          data: formData);
      if (response.statusCode == 200) {
        final summary = Summary.fromJson(response.data);
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          event.fileName: SummaryData(
              status: SummaryStatus.Complete,
              date: DateTime.now(),
              summary: summary.summary)
        });
        emit(state.copyWith(savedLinks: summaryMap));
      } else {
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          event.fileName: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(
          savedLinks: summaryMap,
        ));
      }
    });

    on<DeleteSharedLink>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.remove(event.sharedLink);
      emit(state.copyWith(savedLinks: summaryMap));
    });

    on<CancelRequest>((event, emit) {
      print('!!!!!!');
      cancelToken.cancel("Cancel");
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
      cancelToken = CancelToken();
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
