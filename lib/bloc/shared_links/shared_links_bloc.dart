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
    const duration = Duration(seconds: 90);
    BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: duration,
        receiveTimeout: duration);
    final dio = Dio(options);
    // CancelToken cancelToken = CancelToken();

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
      emit(state.copyWith(savedLinks: summaryMap));
      final response = await dio
          .post(
        'http://51.159.179.125:8001/application_by_summarize/',
        data: {
          'url': event.sharedLink,
          'context': '',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        // cancelToken: cancelToken
      )
          .catchError((onError) {
        summaryMap.addAll({
          event.sharedLink: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(
          savedLinks: summaryMap,
        ));
      });
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
      final response = await dio
          .post(
        'http://51.159.179.125:8001/application_by_summarize/',
        data: {
          'url': '',
          'context': event.text,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        // cancelToken: cancelToken
      )
          .catchError((onError) {
        summaryMap.addAll({
          title: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(
          savedLinks: summaryMap,
        ));
      });
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
      final response = await dio
          .post(
              'http://51.159.179.125:8001/application_by_summarize/uploadfile/',
              options: Options(
                followRedirects: false,
                validateStatus: (status) => true,
              ),
              // cancelToken: cancelToken,
              data: formData)
          .catchError((onError) {
        summaryMap.addAll({
          event.fileName: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(
          savedLinks: summaryMap,
        ));
      });
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
      // cancelToken.cancel("Cancel");
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
      // cancelToken = CancelToken();
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
