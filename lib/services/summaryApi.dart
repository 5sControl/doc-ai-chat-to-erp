import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:summify/models/models.dart';

import 'summary_api_models.dart';

export 'summary_api_models.dart';

enum SendRateStatus { Loading, Sended, Error }

enum SendFeatureStatus { Loading, Sended, Error }

enum SummaryType { long, short }

class SummaryApiRepository {
  /// Primary host: documents, parsing, LLM-backed API (`/api/v1/...`).
  static const String _baseUrlPrimary = 'https://api.lmnotebookpro.com';

  // Planned fallback bases (same paths). Enable cascade in [_postWithFallback] when ready.
  // static const List<String> _fallbackBaseUrls = <String>[
  //   'https://api.employees-training.com',
  //   'https://chromium.employees-training.com',
  // ];

  // API paths (appended to whichever base host is used)
  static const String _pathSummaries = '/api/v1/summaries';
  static const String _pathSummariesFiles = '/api/v1/summaries/files';
  static const String _pathQuestions = '/api/v1/questions';
  static const String _pathQuestionsFiles = '/api/v1/questions/files';
  static const String _pathQuizzesGenerate = '/api/v1/quizzes/generate';
  static const String _pathReviews = '/api/v1/reviews';
  static const String _pathFeedback = '/api/v1/feedback';
  static const String _pathTranslations = '/api/v1/translations';
  static const String _pathKnowledgeCards = '/api/v1/knowledge-cards';
  static const String _pathKnowledgeCardsVerify = '/api/v1/knowledge-cards/verify';

  // Other endpoints (not LM Notebook Pro API; no host fallback)
  final String sendEmailUrl =
      'https://easy4learn.com/django-api/applications/email/';

  // API Key for authentication with document/LLM API
  static const String _apiKey = 'acf8421909af3940f4731f629e28ca486c9ed6af7d7f704a050494773a27c8a9';

  late final Dio _dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
      headers: {
        'X-API-Key': _apiKey,
      },
    ),
  );

  static bool _isNetworkFailure(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        (e.type == DioExceptionType.unknown && e.response == null);
  }

  /// POST to document/LLM API ([_baseUrlPrimary] only for now).
  ///
  /// Fallback cascade through [_fallbackBaseUrls] is prepared but commented out below.
  Future<Response> _postWithFallback(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(
      _baseUrlPrimary + path,
      data: data,
      queryParameters: queryParameters,
    );

    // --- Uncomment to try fallbacks after primary network failure (see _fallbackBaseUrls) ---
    // try {
    //   return await _dio.post(
    //     _baseUrlPrimary + path,
    //     data: data,
    //     queryParameters: queryParameters,
    //   );
    // } on DioException catch (e) {
    //   if (!_isNetworkFailure(e)) rethrow;
    //   DioException? last = e;
    //   for (final base in _fallbackBaseUrls) {
    //     try {
    //       return await _dio.post(
    //         base + path,
    //         data: data,
    //         queryParameters: queryParameters,
    //       );
    //     } on DioException catch (e2) {
    //       last = e2;
    //       if (!_isNetworkFailure(e2)) rethrow;
    //     }
    //   }
    //   throw last!;
    // }
  }

  ErrorDecode _parseDioError(DioException e, {String defaultDetail = 'Processing error'}) {
    try {
      final data = e.response?.data;
      if (data == null) return ErrorDecode(detail: defaultDetail);
      final decodedMap = json.decode(data.toString()) as Map<String, dynamic>?;
      final detail = decodedMap?['detail'];
      return ErrorDecode(detail: detail is String ? detail : defaultDetail);
    } catch (_) {
      return ErrorDecode(detail: defaultDetail);
    }
  }

  Never _throwDioError(DioException e, {String defaultDetail = 'Processing error'}) {
    throw Exception(_parseDioError(e, defaultDetail: defaultDetail).detail);
  }

  static const String _fetchArticlePath = '/fetch';

  /// Fetches article by URL: content, title, image_url. No summarization.
  Future<FetchArticleResult?> fetchArticleByUrl(String url) async {
    try {
      final response = await _postWithFallback(
        _pathSummaries + _fetchArticlePath,
        {'url': url},
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
      try {
        final decoded = json.decode(e.response?.data?.toString() ?? '{}') as Map<String, dynamic>;
        final errorObj = decoded['error'];
        final code = errorObj is Map ? errorObj['code'] as String? : null;
        if (code == 'PAGE_COULD_NOT_LOAD') {
          throw PageCouldNotLoadException();
        }
      } catch (err) {
        if (err is PageCouldNotLoadException) rethrow;
      }
      _throwDioError(e);
    } catch (error) {
      throw Exception('Some error');
    }
  }

  FutureOr<Object?> getFromLink(
      {required String summaryLink, required SummaryType summaryType}) async {
    try {
      Response response = await _postWithFallback(_pathSummaries, {
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
      return Exception(_parseDioError(e).detail);
    } catch (error) {
      return Exception('Some error');
    }
    return null;
  }

  Future<dynamic> getFromText(
      {required String textToSummify, required SummaryType summaryType}) async {
    try {
      Response response = await _postWithFallback(
        _pathSummaries,
        {
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
      return Exception(_parseDioError(e).detail);
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
      Response response = await _postWithFallback(
        _pathSummariesFiles,
        formData,
        queryParameters: {'type_summary': summaryType.name},
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return Summary(
            summaryText: res['summary'], contextLength: res['context_length']);
      }
    } on DioException catch (e) {
      return Exception(_parseDioError(e).detail);
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
      
      Response response = await _postWithFallback(_pathTranslations, requestData);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['translated_text'];
      } else {
        throw Exception('Translation error');
      }
    } on DioException catch (e) {
      _throwDioError(e);
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
      Response response = await _postWithFallback(_pathQuestions, data);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['answer'];
      } else {
        throw Exception('Translation error');
      }
    } on DioException catch (e) {
      _throwDioError(e);
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
      Response response = await _postWithFallback(_pathQuestions, data);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return res['answer'];
      } else {
        throw Exception('Translation error');
      }
    } on DioException catch (e) {
      _throwDioError(e);
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
      Response response = await _postWithFallback(
        _pathQuestionsFiles,
        formData,
        queryParameters: queryParams,
      );
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
  }

  Future<SendRateStatus> sendRate(
      {required String summaryLink,
      required String summary,
      required int rate,
      required String device,
      required String comment}) async {
    try {
      Response response = await _postWithFallback(
        _pathReviews,
        {
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
      Response response = await _postWithFallback(
        _pathFeedback,
        {
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
      Response response = await _postWithFallback(
        _pathQuizzesGenerate,
        {
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
      _throwDioError(e, defaultDetail: 'Failed to generate quiz');
    } catch (error) {
      throw Exception('Failed to generate quiz: $error');
    }
  }

  Future<List<KnowledgeCard>> extractKnowledgeCards(String summaryText) async {
    try {
      Response response = await _postWithFallback(_pathKnowledgeCards, {
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
      _throwDioError(e, defaultDetail: 'Failed to extract knowledge cards');
    } catch (error) {
      throw Exception('Failed to extract knowledge cards: $error');
    }
  }

  /// Verifies user's answer against the card definition.
  /// Returns shortFeedback and accuracy (0-100). API not implemented yet.
  Future<KnowledgeCardVerifyResult> verifyKnowledgeCardAnswer({
    required String cardTitle,
    required String cardContent,
    required String userAnswer,
  }) async {
    try {
      Response response = await _postWithFallback(
        _pathKnowledgeCardsVerify,
        {
          'cardTitle': cardTitle,
          'cardContent': cardContent,
          'userAnswer': userAnswer,
        },
      );

      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        final res = jsonDecode(response.data) as Map<String, dynamic>;
        return KnowledgeCardVerifyResult(
          shortFeedback: res['shortFeedback'] as String? ?? '',
          accuracy: (res['accuracy'] as num?)?.toInt() ?? 0,
        );
      } else {
        throw Exception('Failed to verify answer');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 501) {
        throw KnowledgeCardVerifyUnavailableException();
      }
      _throwDioError(e, defaultDetail: 'Failed to verify answer');
    } catch (error) {
      throw Exception('Failed to verify answer: $error');
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

  Future<KnowledgeCardVerifyResult> verifyKnowledgeCardAnswer({
    required String cardTitle,
    required String cardContent,
    required String userAnswer,
  }) {
    return _summaryRepository.verifyKnowledgeCardAnswer(
      cardTitle: cardTitle,
      cardContent: cardContent,
      userAnswer: userAnswer,
    );
  }
}
