import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

enum SendRateStatus { Loading, Sended, Error }

enum SendFeatureStatus { Loading, Sended, Error }

enum SummaryType { long, short }

class ErrorDecode {
  final String detail;
  ErrorDecode({required this.detail});
}

class SummaryApiRepository {
  final String linkUrl = "http://51.159.179.125:8002/application_by_summarize/";
  final String fileUrl =
      "http://51.159.179.125:8002/application_by_summarize/uploadfile/";
  final String rateUrl = 'http://51.159.179.125:8000/api/applications/reviews/';

  final String requestUrl =
      'http://51.159.179.125:8000/api/applications/function-reports/';

  final String translateUrl =
      'https://largely-whole-horse.ngrok-free.app/translator/translate-to/';

  final String researchUrl =
      'https://largely-whole-horse.ngrok-free.app/fastapi/application_by_summarize/';

  final String researchFile =
      'https://largely-whole-horse.ngrok-free.app/fastapi/application_by_summarize/uploadfile/';

  final Dio _dio = Dio(
    BaseOptions(responseType: ResponseType.plain),
  );

  FutureOr<Object?> getFromLink(
      {required String summaryLink, required SummaryType summaryType}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': summaryLink,
        'context': '',
        "type_summary": summaryType.name
      });

      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        return Summary(summaryText: response.data.toString());
      } else {
        Exception('Some error');
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);

        error = ErrorDecode(
          detail: decodedMap['detail'],
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }

      return Exception(error.detail);
    } catch (error) {
      return Exception('Some error');
    }
    return null;
  }

  Future<dynamic> getFromText(
      {required String textToSummify, required SummaryType summaryType}) async {
    try {
      Response response = await _dio.post(
        linkUrl,
        data: {
          'url': '',
          'context': textToSummify,
          "type_summary": summaryType.name
        },
      );

      if (response.statusCode == 200) {
        return Summary(summaryText: response.data.toString());
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);

        error = ErrorDecode(
          detail: decodedMap['detail'],
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }

      return Exception(error.detail);
    } catch (error) {
      return Exception('Some error');
    }
    return null;
  }

  Future<dynamic> getFromFile(
      {required String fileName,
      required String filePath,
      required SummaryType summaryType}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    try {
      Response response = await _dio.post(fileUrl,
          data: formData, queryParameters: {'type_summary': summaryType.name});

      if (response.statusCode == 200) {
        return Summary(summaryText: response.data.toString());
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);

        error = ErrorDecode(
          detail: decodedMap['detail'],
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }

      return Exception(error.detail);
    } catch (error) {
      return Exception('Some error');
    }
    return null;
  }

  Future<String> translate(
      {required String text, required String languageCode}) async {
    try {
      Response response = await _dio
          .post(translateUrl, data: {'text': text, 'language': languageCode});
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['translated_text'];
      } else {
        throw Exception('Translation error');
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);

        error = ErrorDecode(
          detail: decodedMap['detail'],
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }

      throw Exception(error.detail);
    } catch (error) {
      throw Exception('Some error');
    }
  }

  Future<String> request(
      {required String summaryUrl, required String question}) async {
    try {
      Response response = await _dio.post(researchUrl, data: {
        'url': summaryUrl,
        'user_query': question,
        "context": "",
        "type_summary": "",
      });
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['answer'];
      } else {
        throw Exception('Translation error');
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);

        error = ErrorDecode(
          detail: decodedMap['detail'],
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }

      throw Exception(error.detail);
    } catch (error) {
      throw Exception('Some error');
    }
  }

  Future<String> requestFile(
      {required String filePath, required String question}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    try {
      Response response = await _dio.post(researchFile,
          data: formData, queryParameters: {'user_query': question});
      print(response);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['answer'];
      } else {
        throw Exception('Translation error');
      }
    } catch (e) {
      print(e);
      throw Exception();
    }

    // try {
    //   Response response = await _dio.post(researchUrl, data: {
    //     'url': summaryUrl,
    //     'user_query': question,
    //     "context": "",
    //     "type_summary": "",
    //   });
    //   if (response.statusCode == 200) {
    //     final res = jsonDecode(response.data) as Map<String, dynamic>;
    //     return res['answer'];
    //   } else {
    //     throw Exception('Translation error');
    //   }
    // } on DioException catch (e) {
    //   ErrorDecode error;
    //   try {
    //     final decodedMap = json.decode(e.response?.data);
    //
    //     error = ErrorDecode(
    //       detail: decodedMap['detail'],
    //     );
    //   } catch (e) {
    //     error = ErrorDecode(
    //       detail: 'Processing error',
    //     );
    //   }
    //
    //   throw Exception(error.detail);
    // } catch (error) {
    //   throw Exception('Some error');
    // }
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
      print(_);
      return SendRateStatus.Error;
    } catch (error) {
      print(error);
      return SendRateStatus.Error;
    }
  }

  Future<SendFeatureStatus> requestAFeature({
    required bool getMoreSummaries,
    required bool addTranslation,
    required bool askAQuestions,
    required String addLang,
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      Response response = await _dio.post(
        requestUrl,
        data: {
          "getMoreSummaries": getMoreSummaries,
          "addTranslation": addTranslation,
          "askAQuestions": askAQuestions,
          "addLang": addLang,
          "name": name,
          "email": email,
          "message": message
        },
      );
      if (response.statusCode == 201) {
        return SendFeatureStatus.Sended;
      } else {
        return SendFeatureStatus.Error;
      }
    } on DioException catch (_) {
      return SendFeatureStatus.Error;
    } catch (error) {
      return SendFeatureStatus.Error;
    }
  }
}

class SummaryRepository {
  final SummaryApiRepository _summaryRepository = SummaryApiRepository();

  FutureOr<Object?> getSummaryFromLink(
      {required String summaryLink, required SummaryType summaryType}) {
    return _summaryRepository.getFromLink(
        summaryLink: summaryLink, summaryType: summaryType);
  }

  Future<dynamic> getSummaryFromText(
      {required String textToSummify, required SummaryType summaryType}) {
    return _summaryRepository.getFromText(
        textToSummify: textToSummify, summaryType: summaryType);
  }

  Future<String> getTranslate(
      {required String text, required String languageCode}) {
    return _summaryRepository.translate(text: text, languageCode: languageCode);
  }

  Future<String> makeRequest(
      {required String summaryUrl, required String question}) {
    return _summaryRepository.request(
        question: question, summaryUrl: summaryUrl);
  }

  Future<String> makeRequestFromFile(
      {required String filePath, required String question}) {
    return _summaryRepository.requestFile(
        question: question, filePath: filePath);
  }

  Future<dynamic> getSummaryFromFile(
      {required String fileName,
      required String filePath,
      required SummaryType summaryType}) {
    return _summaryRepository.getFromFile(
        fileName: fileName, filePath: filePath, summaryType: summaryType);
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

  Future<SendFeatureStatus> sendFeature({
    required bool getMoreSummaries,
    required bool addTranslation,
    required bool askAQuestions,
    required String addLang,
    required String name,
    required String email,
    required String message,
  }) {
    return _summaryRepository.requestAFeature(
        getMoreSummaries: getMoreSummaries,
        addTranslation: addTranslation,
        askAQuestions: askAQuestions,
        addLang: addLang,
        name: name,
        email: email,
        message: message);
  }
}
