import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

class SummaryApiRepository {
  final String linkUrl = "http://51.159.179.125:8001/application_by_summarize/";
  final String fileUrl =
      "http://51.159.179.125:8001/application_by_summarize/uploadfile/";
  final Dio _dio = Dio(
    BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json),
  );

  final Map<String, CancelToken> tokens = {};

  void canselRequest({required String canselItem}) {}

  Future<Summary?> getFromLink({required String summaryLink}) async {
    tokens.addAll({summaryLink: CancelToken()});
    try {
      Response response = await _dio.post(linkUrl,
          data: {
            'url': summaryLink,
            'context': '',
          },
          cancelToken: tokens[summaryLink]);
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      return null;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<Summary?> getFromText({required String textToSummify}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': '',
        'context': textToSummify,
      });
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      return null;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future<Summary?> getFromFile(
      {required String fileName, required String filePath}) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      )
    });

    try {
      Response response = await _dio.post(fileUrl, data: formData);
      print(response.data);
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      return null;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}

class SummaryRepository {
  final SummaryApiRepository _summaryRepository = SummaryApiRepository();

  Future<Summary?> getSummaryFromLink({required String summaryLink}) {
    return _summaryRepository.getFromLink(summaryLink: summaryLink);
  }

  Future<Summary?> getSummaryFromText({required String textToSummify}) {
    return _summaryRepository.getFromText(textToSummify: textToSummify);
  }

  Future<Summary?> getSummaryFromFile(
      {required String fileName, required String filePath}) {
    return _summaryRepository.getFromFile(
        fileName: fileName, filePath: filePath);
  }
}
