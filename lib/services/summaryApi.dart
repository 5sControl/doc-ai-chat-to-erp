import 'dart:async';

import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

enum SendRateStatus { Loading, Sended, Error }

class SummaryApiRepository {
  // final String linkUrl = "http://51.159.179.125:8001/application_by_summarize/";
  // final String fileUrl =
  //     "http://51.159.179.125:8001/application_by_summarize/uploadfile/";
  final String rateUrl = 'http://51.159.179.125:8000/api/applications/reviews/';
  final String linkUrl = "http://192.168.1.136:8001/application_by_summarize/";
  final String fileUrl =
      "http://192.168.1.136:8001/application_by_summarize/uploadfile/";

  final Dio _dio = Dio(
    BaseOptions(responseType: ResponseType.plain),
  );

  Future<dynamic> getFromLink({required String summaryLink}) async {
    try {
      Response response = await _dio.post(
        linkUrl,
        data: {'url': summaryLink, 'context': '', "type_summary": "long"},
      ).catchError((e) {
        print(e);
        throw Exception('Loading error');
      });

      if (response.statusCode == 200) {
        return Summary(summary: response.data.toString());
      }
    } on DioException catch (e) {
      print(e);
      return Exception(e.response?.data['detail'] ?? 'Some Error');
    } catch (error) {
      print(error);
      return Exception('Loading error');
    }
  }

  Future<dynamic> getFromText({required String textToSummify}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': '',
        'context': textToSummify,
        "type_summary": "long"
      }).catchError((e) {
        throw Exception('Loading error');
      });
      return Summary(summary: response.data);
    } on DioException catch (e) {
      return Exception(e.response?.data['detail'] ?? 'Some Error');
    } catch (error) {
      return Exception('Loading error');
    }
  }

  Future<dynamic> getFromFile(
      {required String fileName, required String filePath}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    try {
      Response response = await _dio.post(fileUrl,
          data: formData,
          queryParameters: {'type_summary': 'long'}).catchError((e) {
        // print(e);
        throw Exception('Loading error');
      });

      if (response.statusCode == 200) {
        return Summary(summary: response.data.toString());
      }
      // return Summary(summary: response.data.toString());
    } on DioException catch (e) {
      // print(e);
      return Exception(e.response?.data['detail'] ?? 'Some Error');
    } catch (error) {
      // print(error);
      return Exception('Loading error');
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
      if (response.statusCode == 200) {
        return SendRateStatus.Sended;
      } else {
        return SendRateStatus.Error;
      }
    } on DioException catch (_) {
      return SendRateStatus.Error;
    } catch (error) {
      return SendRateStatus.Error;
    }
  }
}

class SummaryRepository {
  final SummaryApiRepository _summaryRepository = SummaryApiRepository();

  Future<dynamic> getSummaryFromLink({required String summaryLink}) {
    return _summaryRepository.getFromLink(summaryLink: summaryLink);
  }

  Future<dynamic> getSummaryFromText({required String textToSummify}) {
    return _summaryRepository.getFromText(textToSummify: textToSummify);
  }

  Future<dynamic> getSummaryFromFile(
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
