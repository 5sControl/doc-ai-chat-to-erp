/// Response models for the v2 Document API.
///
/// These mirror the backend Pydantic schemas in
/// `python-api/app/schemas/document_schemas.py`.

class DocumentSummaryResponse {
  final String id;
  final String sourceType;
  final String? sourceUrl;
  final String title;
  final String? imageUrl;
  final String shortSummaryStatus;
  final String longSummaryStatus;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentSummaryResponse({
    required this.id,
    required this.sourceType,
    this.sourceUrl,
    required this.title,
    this.imageUrl,
    required this.shortSummaryStatus,
    required this.longSummaryStatus,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DocumentSummaryResponse(
      id: json['id'] as String,
      sourceType: json['source_type'] as String,
      sourceUrl: json['source_url'] as String?,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      shortSummaryStatus: json['short_summary_status'] as String,
      longSummaryStatus: json['long_summary_status'] as String,
      isBlocked: json['is_blocked'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class CardResponse {
  final String id;
  final String cardType;
  final String title;
  final String content;
  final String? explanation;
  final bool isSaved;
  final DateTime createdAt;

  CardResponse({
    required this.id,
    required this.cardType,
    required this.title,
    required this.content,
    this.explanation,
    required this.isSaved,
    required this.createdAt,
  });

  factory CardResponse.fromJson(Map<String, dynamic> json) {
    return CardResponse(
      id: json['id'] as String,
      cardType: json['card_type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      explanation: json['explanation'] as String?,
      isSaved: json['is_saved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class QuizResponse {
  final String id;
  final List<dynamic> questions;
  final List<dynamic> userAnswers;
  final String status;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizResponse({
    required this.id,
    required this.questions,
    required this.userAnswers,
    required this.status,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      id: json['id'] as String,
      questions: json['questions'] as List<dynamic>? ?? [],
      userAnswers: json['user_answers'] as List<dynamic>? ?? [],
      status: json['status'] as String,
      score: json['score'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class MessageResponse {
  final String id;
  final int sortOrder;
  final String question;
  final String? answer;
  final String status;
  final bool isLiked;
  final DateTime createdAt;

  MessageResponse({
    required this.id,
    required this.sortOrder,
    required this.question,
    this.answer,
    required this.status,
    required this.isLiked,
    required this.createdAt,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      id: json['id'] as String,
      sortOrder: json['sort_order'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String?,
      status: json['status'] as String,
      isLiked: json['is_liked'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class TranslationResponse {
  final String id;
  final String summaryType;
  final String language;
  final String content;
  final DateTime createdAt;

  TranslationResponse({
    required this.id,
    required this.summaryType,
    required this.language,
    required this.content,
    required this.createdAt,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      id: json['id'] as String,
      summaryType: json['summary_type'] as String,
      language: json['language'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class DocumentDetailResponse {
  final String id;
  final String sourceType;
  final String? sourceUrl;
  final String title;
  final String? imageUrl;
  final String? originalText;
  final String? shortSummary;
  final String? longSummary;
  final String shortSummaryStatus;
  final String longSummaryStatus;
  final int? contextLength;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CardResponse> knowledgeCards;
  final List<QuizResponse> quizzes;
  final List<MessageResponse> researchMessages;
  final List<TranslationResponse> translations;

  DocumentDetailResponse({
    required this.id,
    required this.sourceType,
    this.sourceUrl,
    required this.title,
    this.imageUrl,
    this.originalText,
    this.shortSummary,
    this.longSummary,
    required this.shortSummaryStatus,
    required this.longSummaryStatus,
    this.contextLength,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
    required this.knowledgeCards,
    required this.quizzes,
    required this.researchMessages,
    required this.translations,
  });

  factory DocumentDetailResponse.fromJson(Map<String, dynamic> json) {
    return DocumentDetailResponse(
      id: json['id'] as String,
      sourceType: json['source_type'] as String,
      sourceUrl: json['source_url'] as String?,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      originalText: json['original_text'] as String?,
      shortSummary: json['short_summary'] as String?,
      longSummary: json['long_summary'] as String?,
      shortSummaryStatus: json['short_summary_status'] as String,
      longSummaryStatus: json['long_summary_status'] as String,
      contextLength: json['context_length'] as int?,
      isBlocked: json['is_blocked'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      knowledgeCards: (json['knowledge_cards'] as List<dynamic>?)
              ?.map((e) => CardResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((e) => QuizResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      researchMessages: (json['research_messages'] as List<dynamic>?)
              ?.map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      translations: (json['translations'] as List<dynamic>?)
              ?.map(
                  (e) => TranslationResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PaginatedDocumentsResponse {
  final List<DocumentSummaryResponse> items;
  final int total;
  final int page;
  final int pageSize;

  PaginatedDocumentsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory PaginatedDocumentsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedDocumentsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              DocumentSummaryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }
}

class MigrateDocumentResponse {
  final String documentId;
  final List<String> cardIds;
  final String? quizId;

  MigrateDocumentResponse({
    required this.documentId,
    required this.cardIds,
    this.quizId,
  });

  factory MigrateDocumentResponse.fromJson(Map<String, dynamic> json) {
    return MigrateDocumentResponse(
      documentId: json['document_id'] as String,
      cardIds: (json['card_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      quizId: json['quiz_id'] as String?,
    );
  }
}
