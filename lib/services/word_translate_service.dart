import 'package:translator/translator.dart';

import 'summaryApi.dart';

/// Result of a single-word lookup: word, translation, and optional extra fields.
class WordLookupResult {
  final String word;
  final String translation;
  final String? transcription;
  final String? contextNote;
  final String? errorMessage;
  final List<String>? extraDefinitions;

  const WordLookupResult({
    required this.word,
    required this.translation,
    this.transcription,
    this.contextNote,
    this.errorMessage,
    this.extraDefinitions,
  });

  bool get isError => errorMessage != null;
}

/// LRU cache for up to [capacity] word lookups. Key format: "normalizedWord|targetLang".
class _LRUCache<K, V> {
  final int capacity;
  final Map<K, V> _map = {};
  final List<K> _order = [];

  _LRUCache({this.capacity = 10});

  V? get(K key) {
    if (!_map.containsKey(key)) return null;
    _order.remove(key);
    _order.add(key);
    return _map[key];
  }

  void put(K key, V value) {
    if (_map.containsKey(key)) {
      _order.remove(key);
    } else if (_order.length >= capacity) {
      final evicted = _order.removeAt(0);
      _map.remove(evicted);
    }
    _order.add(key);
    _map[key] = value;
  }
}

/// Extracts the sentence surrounding [word] from [fullText].
/// Returns null if the word is not found. Caps at ~300 chars.
String? extractSentenceContext(String fullText, String word) {
  final idx = fullText.toLowerCase().indexOf(word.toLowerCase());
  if (idx < 0) return null;

  const sentenceBreaks = {'.', '!', '?', '\n'};
  int start = idx;
  while (start > 0 && !sentenceBreaks.contains(fullText[start - 1])) {
    start--;
  }
  int end = idx + word.length;
  while (end < fullText.length && !sentenceBreaks.contains(fullText[end])) {
    end++;
  }
  // Include the terminating punctuation if present.
  if (end < fullText.length && sentenceBreaks.contains(fullText[end]) && fullText[end] != '\n') {
    end++;
  }

  var sentence = fullText.substring(start, end).trim();
  if (sentence.length > 300) {
    sentence = sentence.substring(0, 300);
  }
  return sentence.isEmpty ? null : sentence;
}

/// Service for translating a single word, with backend API (context-aware) and
/// Google Translate fallback for multi-word selections.
class WordTranslateService {
  WordTranslateService._();
  static final WordTranslateService instance = WordTranslateService._();

  static const int _cacheCapacity = 10;
  final _cache = _LRUCache<String, WordLookupResult>(capacity: _cacheCapacity);
  final GoogleTranslator _translator = GoogleTranslator();

  /// Normalize word for display and cache: trim, strip leading/trailing punctuation.
  static String normalizeWord(String word) {
    final t = word.trim();
    if (t.isEmpty) return t;
    int start = 0;
    int end = t.length;
    while (start < end && _isPunctuation(t[start])) {
      start++;
    }
    while (end > start && _isPunctuation(t[end - 1])) {
      end--;
    }
    return start < end ? t.substring(start, end) : t;
  }

  static bool _isPunctuation(String c) {
    const punct = '.,;:!?"\'[])\\-–—';
    return punct.contains(c);
  }

  static String _cacheKey(String normalizedWord, String targetLang) {
    return '${normalizedWord.toLowerCase()}|$targetLang';
  }

  static bool _isSingleWord(String text) => !text.contains(RegExp(r'\s'));

  /// Look up translation for [word].
  ///
  /// Single words with [sentenceContext] use the backend language-proxy API
  /// (`translate_with_context`); on API failure, falls back to Google Translate.
  /// Multi-word selections always use Google Translate directly.
  Future<WordLookupResult> lookup(
    String word,
    String targetLang, {
    String? sentenceContext,
  }) async {
    final normalized = normalizeWord(word);
    if (normalized.isEmpty) {
      return WordLookupResult(
        word: word,
        translation: '',
        errorMessage: 'Empty word',
      );
    }

    final key = _cacheKey(normalized, targetLang);
    final cached = _cache.get(key);
    if (cached != null) return cached;

    if (_isSingleWord(normalized) && sentenceContext != null) {
      try {
        final result = await _lookupViaApi(normalized, targetLang, sentenceContext);
        _cache.put(key, result);
        return result;
      } catch (_) {
        // Fall through to Google Translate on any API error.
      }
    }

    return _lookupViaGoogleTranslate(normalized, targetLang, key);
  }

  /// Backend API call using `translate_with_context` template.
  Future<WordLookupResult> _lookupViaApi(
    String word,
    String targetLang,
    String context,
  ) async {
    final api = SummaryApiRepository();
    final json = await api.languageCompletion(
      promptTemplate: 'translate_with_context',
      templateParams: {
        'target_language': targetLang,
        'context': context,
      },
      message: word,
    );
    return WordLookupResult(
      word: word,
      translation: (json['translation'] as String?) ?? '',
      transcription: (json['transcription'] as String?),
      contextNote: (json['context_note'] as String?),
    );
  }

  /// Fallback: free Google Translate (no context, no transcription).
  Future<WordLookupResult> _lookupViaGoogleTranslate(
    String normalized,
    String targetLang,
    String cacheKey,
  ) async {
    try {
      final result = await _translator.translate(
        normalized,
        from: 'auto',
        to: targetLang,
      );
      final lookup = WordLookupResult(
        word: normalized,
        translation: result.text,
      );
      _cache.put(cacheKey, lookup);
      return lookup;
    } catch (e) {
      return WordLookupResult(
        word: normalized,
        translation: '',
        errorMessage: e.toString(),
      );
    }
  }
}
