import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

class SummaryApiRepository {
  final String linkUrl = "http://51.159.179.125:8001/application_by_summarize/";
  final Dio _dio = Dio(
    BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json),
  );

  Future<Summary?> getFromLink({required String summaryLink}) async {
    try {
      Response response = await _dio.post(linkUrl, data: {
        'url': summaryLink,
        'context': '',
      });
      return Summary.fromJson(response.data);
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
}

// class Paths {
//   static String linkUrl =
//       "http://51.159.179.125:8001/application_by_summarize/";
// }
//
// class DioClient {
//   DioClient._();
//
//   static final instance = DioClient._();
//
//   factory DioClient() {
//     return instance;
//   }
//
//   final Dio _dio = Dio(
//     BaseOptions(
//         baseUrl: Paths.linkUrl,
//         connectTimeout: const Duration(seconds: 60),
//         receiveTimeout: const Duration(seconds: 60),
//         responseType: ResponseType.json),
//   );
//
//   Future<Map<String, dynamic>> getSummaryFromUrl(String summaryLink,
//       {Map<String, dynamic>? queryParameters,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onReceiveProgress}) async {
//     try {
//       final Response response = await _dio.get(Paths.linkUrl,
//           queryParameters: queryParameters,
//           options: options,
//           cancelToken: cancelToken,
//           onReceiveProgress: onReceiveProgress,
//           data: {
//             'url': summaryLink,
//             'context': '',
//           });
//       if (response.statusCode == 200) {
//         return response.data;
//       }
//       throw "something went wrong";
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
//
// class SummaryService {
//   Future<Summary?> getSummaryFromUrl(String summaryLink) async {
//     try {
//       final response = await DioClient.instance.getSummaryFromUrl(summaryLink);
//       final user = Summary.fromJson(response["data"]);
//       return user;
//     } on DioException catch (e) {
//       // var error = DioErrors(e);
//       // throw error.errorMessage;
//       return null;
//     }
//   }
// }
