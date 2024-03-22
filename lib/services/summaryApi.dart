import 'dart:async';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

enum SendRateStatus { Loding, Sended, Error }

class SummaryApiRepository {
  final String linkUrl = "http://51.159.179.125:8001/application_by_summarize/";
  final String fileUrl =
      "http://51.159.179.125:8001/application_by_summarize/uploadfile/";
  final String rateUrl = 'http://51.159.179.125:8001/api/applications/reviews/';
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
      ).catchError(() {
        return const Summary(summary: null, summaryError: 'Loading error');
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

  Future<Summary> getFromText({required String textToSummify}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': '',
        'context': textToSummify,
      }).catchError(() {
        return const Summary(summary: null, summaryError: 'Loading error');
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
      Response response =
          await _dio.post(fileUrl, data: formData).catchError(() {
        return const Summary(summary: null, summaryError: 'Loading error');
      });
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      return Summary(
          summary: null,
          summaryError: e.response?.data['detail'].toString() ?? 'Some Error');
    } catch (error, stacktrace) {
      return const Summary(summary: null, summaryError: 'Loading error');
    }
  }

  Future<SendRateStatus> sendRate(
      {required String summaryLink,
      required String summary,
      required int rate,
      required String device,
      required String comment}) async {
    try {
      Response response = await _dio.post(
        rateUrl,
        data: {
          'comment': comment,
          'device': device,
          'grade': rate,
          'summary': summary,
          'source': summaryLink,
        },
      );
      if (response.statusCode == 201) {
        print('Send rate');
        return SendRateStatus.Sended;
      } else {
        return SendRateStatus.Error;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      return SendRateStatus.Error;
    } catch (error, stacktrace) {
      print(error);
      return SendRateStatus.Error;
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

  Future<SendRateStatus> sendSummaryRate(
      {required String summaryLink,
      required String summary,
      required int rate,
      required String device,
      required String comment}) {
    return _summaryRepository.sendRate(
        summary: summary,
        summaryLink: summaryLink,
        comment: comment,
        device: device,
        rate: rate);
  }
}
