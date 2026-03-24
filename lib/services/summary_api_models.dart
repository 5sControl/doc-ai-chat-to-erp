/// API error detail from server JSON response.
class ErrorDecode {
  final String detail;

  ErrorDecode({required this.detail});
}

/// Thrown when server returns 404 with error.code PAGE_COULD_NOT_LOAD (show copy-paste dialog).
class PageCouldNotLoadException implements Exception {}

/// Result of fetching an article by URL (content, title, image URL for list preview).
class FetchArticleResult {
  final String content;
  final String? title;
  final String? imageUrl;

  FetchArticleResult({required this.content, this.title, this.imageUrl});
}

/// Result of knowledge card answer verification.
class KnowledgeCardVerifyResult {
  final String shortFeedback;
  final int accuracy;

  KnowledgeCardVerifyResult({
    required this.shortFeedback,
    required this.accuracy,
  });
}

/// Thrown when verify endpoint is not implemented yet (404/501).
class KnowledgeCardVerifyUnavailableException implements Exception {}
