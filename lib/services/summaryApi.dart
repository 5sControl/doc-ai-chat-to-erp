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

/// Result of fetching an article by URL (content, title, image URL for list preview).
class FetchArticleResult {
  final String content;
  final String? title;
  final String? imageUrl;

  FetchArticleResult({required this.content, this.title, this.imageUrl});
}

class SummaryApiRepository {
  // Summarization endpoints
  final String summarizeUrl =
      "https://employees-training.com/api/v1/summaries";

  final String summarizeFileUrl =
      "https://employees-training.com/api/v1/summaries/files";

  // Question answering endpoints
  final String askQuestionUrl =
      "https://employees-training.com/api/v1/questions";

  final String askQuestionFileUrl =
      "https://employees-training.com/api/v1/questions/files";

  // Quiz generation endpoint
  final String generateQuizUrl =
      "https://employees-training.com/api/v1/quizzes/generate";

  // Other endpoints
  final String reviewsUrl =
      'https://employees-training.com/api/v1/reviews';

  final String feedbackUrl =
      'https://employees-training.com/api/v1/feedback';

  final String translateUrl =
      'https://employees-training.com/api/v1/translations';

  final String sendEmailUrl =
      'https://easy4learn.com/django-api/applications/email/';

  // Knowledge cards extraction endpoint
  final String extractKnowledgeCardsUrl =
      "https://employees-training.com/api/v1/knowledge-cards";

  // API Key for authentication with employees-training.com API
  // Using a static key to avoid build-time complexities
  static const String _apiKey = 'acf8421909af3940f4731f629e28ca486c9ed6af7d7f704a050494773a27c8a9';

  // Initialize Dio with API key header
  late final Dio _dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
      headers: {
        'X-API-Key': _apiKey,
      },
    ),
  );

  static const String _fetchArticlePath = '/fetch';

  /// Fetches article by URL: content, title, image_url. No summarization.
  Future<FetchArticleResult?> fetchArticleByUrl(String url) async {
    try {
      final response = await _dio.post(
        summarizeUrl + _fetchArticlePath,
        data: {'url': url},
      );
      if (response.statusCode == 200 && response.data != null) {
        final res = jsonDecode(response.data.toString()) as Map<String, dynamic>;
        final imageUrl = res['image_url'] as String?;
        return FetchArticleResult(
          content: res['content'] as String,
          title: res['title'] as String?,
          imageUrl: imageUrl != null && imageUrl.isNotEmpty ? imageUrl : null,
        );
      }
      return null;
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);
        error = ErrorDecode(detail: decodedMap['detail']);
      } catch (_) {
        error = ErrorDecode(detail: 'Processing error');
      }
      throw Exception(error.detail);
    } catch (error) {
      throw Exception('Some error');
    }
  }

  FutureOr<Object?> getFromLink(
      {required String summaryLink, required SummaryType summaryType}) async {
    try {
      Response response = await _dio.post(summarizeUrl, data: {
        'url': summaryLink,
        'context': '',
        "type_summary": summaryType.name
      });

      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return Summary(
            summaryText: res['summary'], contextLength: res['context_length']);
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
        summarizeUrl,
        data: {
          'url': '',
          'context': textToSummify,
          "type_summary": summaryType.name
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return Summary(
            summaryText: res['summary'], contextLength: res['context_length']);
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
      Response response = await _dio.post(summarizeFileUrl,
          data: formData, queryParameters: {'type_summary': summaryType.name});

      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return Summary(
            summaryText: res['summary'], contextLength: res['context_length']);
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
      {required String text, required String languageCode, String? languageName}) async {
    try {
      // Send both language_name (preferred) and language (backward compatibility)
      final requestData = {
        'text': text,
        'language': languageCode,
      };
      
      // Add language_name if provided - server will prioritize this
      if (languageName != null && languageName.isNotEmpty) {
        requestData['language_name'] = languageName;
      }
      
      Response response = await _dio.post(translateUrl, data: requestData);
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

  Future<String> request({
    required String summaryUrl,
    required String question,
    String? systemHint,
  }) async {
    try {
      final data = <String, dynamic>{
        'url': summaryUrl,
        'context': "",
        'user_query': question,
      };
      if (systemHint != null && systemHint.isNotEmpty) {
        data['system_hint'] = systemHint;
      }
      Response response = await _dio.post(askQuestionUrl, data: data);
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

  Future<String> requestText({
    required String userText,
    required String question,
    String? systemHint,
  }) async {
    try {
      final data = <String, dynamic>{
        'url': '',
        'context': userText,
        'user_query': question,
      };
      if (systemHint != null && systemHint.isNotEmpty) {
        data['system_hint'] = systemHint;
      }
      Response response = await _dio.post(askQuestionUrl, data: data);
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

  Future<String> requestFile({
    required String filePath,
    required String question,
    String? systemHint,
  }) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    try {
      final queryParams = <String, dynamic>{'user_query': question};
      if (systemHint != null && systemHint.isNotEmpty) {
        queryParams['system_hint'] = systemHint;
      }
      Response response = await _dio.post(askQuestionFileUrl,
          data: formData, queryParameters: queryParams);
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
        reviewsUrl,
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
    } on DioException catch (e) {
      print(e);
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
    required bool readBook,
    required String addLang,
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      Response response = await _dio.post(
        feedbackUrl,
        data: {
          "getMoreSummaries": getMoreSummaries,
          "addTranslation": addTranslation,
          "askAQuestions": askAQuestions,
          "readBook": readBook,
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

  Future<void> sendEmail({
    required String email,
  }) async {
    try {
      Response response = await _dio.post(
        sendEmailUrl,
        data: {
          "email": email,
        },
      );
      if (response.statusCode == 201) {
        print(response.data);
      } else {
        print(response.data);
      }
    } on DioException catch (e) {
      return print(e);
    } catch (error) {
      return print(error);
    }
  }

  Future<Quiz> generateQuizFromText({
    required String text,
    int numQuestions = 5,
    String difficulty = "medium",
  }) async {
    try {
      Response response = await _dio.post(
        generateQuizUrl,
        data: {
          'text': text,
          'num_questions': numQuestions,
          'difficulty': difficulty,
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        
        // Parse quiz data
        final quizId = res['quiz_id'] as String;
        final questionsList = res['questions'] as List<dynamic>;
        final generatedAtStr = res['generated_at'] as String?;
        
        final questions = questionsList.map((q) {
          final questionData = q as Map<String, dynamic>;
          final optionsList = questionData['options'] as List<dynamic>;
          
          final options = optionsList.map((opt) {
            final optData = opt as Map<String, dynamic>;
            return QuizOption(
              id: optData['id'] as String,
              text: optData['text'] as String,
            );
          }).toList();
          
          return QuizQuestion(
            id: questionData['id'] as String,
            question: questionData['question'] as String,
            options: options,
            correctAnswerId: questionData['correct_answer_id'] as String,
            explanation: questionData['explanation'] as String,
          );
        }).toList();
        
        final generatedAt = generatedAtStr != null
            ? DateTime.parse(generatedAtStr)
            : DateTime.now();
        
        return Quiz(
          quizId: quizId,
          documentKey: '', // Will be set by the caller
          questions: questions,
          status: QuizStatus.ready,
          generatedAt: generatedAt,
          currentQuestionIndex: 0,
        );
      } else {
        throw Exception('Failed to generate quiz');
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);
        error = ErrorDecode(
          detail: decodedMap['detail'] ?? 'Failed to generate quiz',
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }
      throw Exception(error.detail);
    } catch (error) {
      throw Exception('Failed to generate quiz: $error');
    }
  }

  Future<List<KnowledgeCard>> extractKnowledgeCards(String summaryText) async {
    try {
      Response response = await _dio.post(extractKnowledgeCardsUrl, data: {
        'text': summaryText,
      });

      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        final cardsData = res['cards'] as List<dynamic>;

        return cardsData.map((cardData) {
          final card = cardData as Map<String, dynamic>;
          return KnowledgeCard(
            id: card['id'] as String,
            type: KnowledgeCardType.values.firstWhere(
              (e) => e.name == card['type'],
              orElse: () => KnowledgeCardType.insight,
            ),
            title: card['title'] as String,
            content: card['content'] as String,
            explanation: card['explanation'] as String?,
            isSaved: false, // Default to not saved
            extractedAt: DateTime.now(),
          );
        }).toList();
      } else {
        throw Exception('Failed to extract knowledge cards');
      }
    } on DioException catch (e) {
      ErrorDecode error;
      try {
        final decodedMap = json.decode(e.response?.data);
        error = ErrorDecode(
          detail: decodedMap['detail'] ?? 'Failed to extract knowledge cards',
        );
      } catch (e) {
        error = ErrorDecode(
          detail: 'Processing error',
        );
      }
      throw Exception(error.detail);
    } catch (error) {
      throw Exception('Failed to extract knowledge cards: $error');
    }
  }
}

class SummaryRepository {
  final SummaryApiRepository _summaryRepository = SummaryApiRepository();

  Future<FetchArticleResult?> getArticleByUrl(String url) {
    return _summaryRepository.fetchArticleByUrl(url);
  }

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
      {required String text, required String languageCode, String? languageName}) {
    return _summaryRepository.translate(
      text: text, 
      languageCode: languageCode,
      languageName: languageName,
    );
  }

  Future<String> makeRequest({
    required String summaryUrl,
    required String question,
    String? systemHint,
  }) {
    return _summaryRepository.request(
      question: question,
      summaryUrl: summaryUrl,
      systemHint: systemHint,
    );
  }

  Future<String> makeRequestFromText({
    required String userText,
    required String question,
    String? systemHint,
  }) {
    return _summaryRepository.requestText(
      question: question,
      userText: userText,
      systemHint: systemHint,
    );
  }

  Future<String> makeRequestFromFile({
    required String filePath,
    required String question,
    String? systemHint,
  }) {
    return _summaryRepository.requestFile(
      question: question,
      filePath: filePath,
      systemHint: systemHint,
    );
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
    required bool readBook,
    required String addLang,
    required String name,
    required String email,
    required String message,
  }) {
    return _summaryRepository.requestAFeature(
      getMoreSummaries: getMoreSummaries,
      addTranslation: addTranslation,
      askAQuestions: askAQuestions,
      readBook: readBook,
      addLang: addLang,
      name: name,
      email: email,
      message: message,
    );
  }

  Future<void> sendEmailForPremium({required String email}) {
    return _summaryRepository.sendEmail(email: email);
  }

  Future<Quiz> generateQuizFromText({
    required String text,
    required String documentKey,
    int numQuestions = 5,
    String difficulty = "medium",
  }) {
    return _summaryRepository.generateQuizFromText(
      text: text,
      numQuestions: numQuestions,
      difficulty: difficulty,
    ).then((quiz) => quiz.copyWith(documentKey: documentKey));
  }

  Future<List<KnowledgeCard>> extractKnowledgeCards(String summaryText) {
    return _summaryRepository.extractKnowledgeCards(summaryText);
  }
}
