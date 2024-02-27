import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../models/models.dart';

part 'shared_links_event.dart';
part 'shared_links_state.dart';
part 'shared_links_bloc.g.dart';

class SharedLinksBloc extends HydratedBloc<SharedLinksEvent, SharedLinksState> {
  SharedLinksBloc() : super(const SharedLinksState(savedLinks: {})) {
    // on<SaveSharedItem>((event, emit) {
    //   print(event.sharedItem.path);
    //   emit(state.copyWith(
    //       savedSharedLinks: [...state.savedSharedLinks, event.sharedItem]));
    // });

    on<SaveSharedLink>((event, emit) async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onError: (DioException error, ErrorInterceptorHandler handler) {
            return handler.next(error);
          },
        ),
      );
      final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
      summaryMap.addAll({
        event.sharedLink: SummaryData(
            status: SummaryStatus.Loading, summary: null, date: DateTime.now())
      });
      emit(state.copyWith(savedLinks: summaryMap));
      // print('loading');
      final response = await dio.post(
        'http://51.159.179.125:8001/url_to_summarize/',
        data: {
          'url': event.sharedLink,
        },
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final summary = Summary.fromJson(response.data);
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          event.sharedLink: SummaryData(
              status: SummaryStatus.Complete,
              summary: summary,
              date: DateTime.now())
        });
        emit(state.copyWith(savedLinks: summaryMap));
      } else if (response.statusCode == 500) {
        final Map<String, SummaryData> summaryMap = Map.from(state.savedLinks);
        summaryMap.addAll({
          event.sharedLink: SummaryData(
              status: SummaryStatus.Error, summary: null, date: DateTime.now())
        });
        emit(state.copyWith(savedLinks: summaryMap));
      }
      print('complete');
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
