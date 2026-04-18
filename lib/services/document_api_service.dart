import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'document_api_models.dart';

/// HTTP client for the v2 Document API (`/api/v2/*`).
///
/// Uses Firebase ID tokens for authentication instead of the static API key
/// used by v1 endpoints.
class DocumentApiService {
  static const String _baseUrl = 'https://api.lmnotebookpro.com';

  static final DocumentApiService _instance = DocumentApiService._internal();
  factory DocumentApiService() => _instance;

  DocumentApiService._internal();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      responseType: ResponseType.plain,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
    ),
  )..interceptors.add(_FirebaseAuthInterceptor());

  // ── Documents ──

  Future<DocumentDetailResponse> createDocument({
    required String sourceType,
    required String title,
    String? sourceUrl,
    String? originalText,
    String? context,
    String? imageUrl,
    String typeSummary = 'short',
  }) async {
    final response = await _dio.post(
      '/api/v2/documents',
      data: jsonEncode({
        'source_type': sourceType,
        'title': title,
        if (sourceUrl != null) 'source_url': sourceUrl,
        if (originalText != null) 'original_text': originalText,
        if (context != null) 'context': context,
        if (imageUrl != null) 'image_url': imageUrl,
        'type_summary': typeSummary,
      }),
      options: Options(contentType: 'application/json'),
    );
    return DocumentDetailResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  Future<DocumentDetailResponse> uploadDocument({
    required String filePath,
    required String fileName,
    String typeSummary = 'short',
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _dio.post(
      '/api/v2/documents/upload',
      data: formData,
      queryParameters: {'type_summary': typeSummary},
    );
    return DocumentDetailResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  Future<PaginatedDocumentsResponse> listDocuments({
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await _dio.get(
      '/api/v2/documents',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return PaginatedDocumentsResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  Future<DocumentDetailResponse> getDocument(String docId) async {
    final response = await _dio.get('/api/v2/documents/$docId');
    return DocumentDetailResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  Future<void> deleteDocument(String docId) async {
    await _dio.delete('/api/v2/documents/$docId');
  }

  // ── Knowledge Cards ──

  Future<List<CardResponse>> getCards(String docId) async {
    final response = await _dio.get('/api/v2/documents/$docId/cards');
    final list = jsonDecode(response.data as String) as List<dynamic>;
    return list
        .map((e) => CardResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CardResponse> updateCard(
    String docId,
    String cardId, {
    bool? isSaved,
    String? title,
    String? content,
    String? explanation,
  }) async {
    final response = await _dio.patch(
      '/api/v2/documents/$docId/cards/$cardId',
      data: jsonEncode({
        if (isSaved != null) 'is_saved': isSaved,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (explanation != null) 'explanation': explanation,
      }),
      options: Options(contentType: 'application/json'),
    );
    return CardResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  // ── Quiz ──

  Future<QuizResponse?> getQuiz(String docId) async {
    final response = await _dio.get('/api/v2/documents/$docId/quiz');
    final decoded = jsonDecode(response.data as String);
    if (decoded == null) return null;
    return QuizResponse.fromJson(decoded as Map<String, dynamic>);
  }

  Future<QuizResponse> updateQuiz(
    String docId, {
    List<dynamic>? userAnswers,
    String? status,
    int? score,
  }) async {
    final response = await _dio.put(
      '/api/v2/documents/$docId/quiz',
      data: jsonEncode({
        if (userAnswers != null) 'user_answers': userAnswers,
        if (status != null) 'status': status,
        if (score != null) 'score': score,
      }),
      options: Options(contentType: 'application/json'),
    );
    return QuizResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  // ── Chat / Research ──

  Future<List<MessageResponse>> getChat(String docId) async {
    final response = await _dio.get('/api/v2/documents/$docId/chat');
    final list = jsonDecode(response.data as String) as List<dynamic>;
    return list
        .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageResponse> sendMessage(
    String docId, {
    required String question,
    String? systemHint,
  }) async {
    final response = await _dio.post(
      '/api/v2/documents/$docId/chat',
      data: jsonEncode({
        'question': question,
        if (systemHint != null) 'system_hint': systemHint,
      }),
      options: Options(contentType: 'application/json'),
    );
    return MessageResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  // ── Migration ──

  Future<MigrateDocumentResponse> migrateDocument({
    required String localKey,
    required String sourceType,
    required String title,
    String? imageUrl,
    String? sourceUrl,
    String? originalText,
    String? shortSummary,
    String? longSummary,
    String shortSummaryStatus = 'initial',
    String longSummaryStatus = 'initial',
    int? contextLength,
    bool isBlocked = false,
    List<Map<String, dynamic>> knowledgeCards = const [],
    Map<String, dynamic>? quiz,
    List<Map<String, dynamic>> researchMessages = const [],
    List<Map<String, dynamic>> translations = const [],
  }) async {
    final response = await _dio.post(
      '/api/v2/documents/migrate',
      data: jsonEncode({
        'local_key': localKey,
        'source_type': sourceType,
        'title': title,
        if (imageUrl != null) 'image_url': imageUrl,
        if (sourceUrl != null) 'source_url': sourceUrl,
        if (originalText != null) 'original_text': originalText,
        if (shortSummary != null) 'short_summary': shortSummary,
        if (longSummary != null) 'long_summary': longSummary,
        'short_summary_status': shortSummaryStatus,
        'long_summary_status': longSummaryStatus,
        if (contextLength != null) 'context_length': contextLength,
        'is_blocked': isBlocked,
        'knowledge_cards': knowledgeCards,
        if (quiz != null) 'quiz': quiz,
        'research_messages': researchMessages,
        'translations': translations,
      }),
      options: Options(contentType: 'application/json'),
    );
    return MigrateDocumentResponse.fromJson(
      jsonDecode(response.data as String) as Map<String, dynamic>,
    );
  }

  // ── User settings ──

  Future<void> updateUserSettings({
    String? displayName,
    String? email,
  }) async {
    await _dio.put(
      '/api/v2/user/settings',
      data: jsonEncode({
        if (displayName != null) 'display_name': displayName,
        if (email != null) 'email': email,
      }),
      options: Options(contentType: 'application/json'),
    );
  }
}

/// Dio interceptor that attaches the current Firebase ID token
/// as a Bearer header to every request.
class _FirebaseAuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        options.headers['Authorization'] = 'Bearer $token';
      } catch (_) {
        // Token fetch failed; let the request proceed without auth.
        // The server will return 401, which the caller can handle.
      }
    }
    handler.next(options);
  }
}
