import 'dart:async';

import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

class SummaryApiRepository {
  final String linkUrl = "http://51.159.179.125:8001/application_by_summarize/";
  final String fileUrl =
      "http://51.159.179.125:8001/application_by_summarize/uploadfile/";
  // final String linkUrl = "http://192.168.1.136:8000/application_by_summarize/";
  // final String fileUrl =
  //     "http://192.168.1.136:8000/application_by_summarize/uploadfile/";
  final Dio _dio = Dio(
    BaseOptions(responseType: ResponseType.json),
  );

  Future<Summary> getFromLink({required String summaryLink}) async {
    try {
      Response response = await _dio.post(
        linkUrl,
        data: {
          'url': summaryLink,
          'context': '',
        },
      );
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      return Summary(
          summary: null,
          summaryError: e.response?.data['detail'] ?? 'Some Error');
    } catch (error, stacktrace) {
      return const Summary(summary: null, summaryError: 'Loading error');
    }
  }

  Future<Summary> getFromText({required String textToSummify}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': '',
        'context': textToSummify,
      });
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      return Summary(
          summary: null,
          summaryError: e.response?.data['detail'] ?? 'Some Error');
    } catch (error, stacktrace) {
      return const Summary(summary: null, summaryError: 'Loading error');
    }
  }

  Future<Summary> getFromFile(
      {required String fileName, required String filePath}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      )
    });

    try {
      Response response = await _dio.post(fileUrl, data: formData);
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      return Summary(
          summary: null,
          summaryError: e.response?.data['detail'] ?? 'Some Error');
    } catch (error, stacktrace) {
      return const Summary(summary: null, summaryError: 'Loading error');
    }
  }
}

class SummaryRepository {
  final SummaryApiRepository _summaryRepository = SummaryApiRepository();

  Future<Summary> getSummaryFromLink({required String summaryLink}) {
    return _summaryRepository.getFromLink(summaryLink: summaryLink);
  }

  Future<Summary> getSummaryFromText({required String textToSummify}) {
    return _summaryRepository.getFromText(textToSummify: textToSummify);
  }

  Future<Summary> getSummaryFromFile(
      {required String fileName, required String filePath}) {
    return _summaryRepository.getFromFile(
        fileName: fileName, filePath: filePath);
  }
}
