import 'package:translator/translator.dart';

/// Result of a single-word lookup: word, translation, and optional extra definitions.
class WordLookupResult {
  final String word;
  final String translation;
  final String? errorMessage;
  final List<String>? extraDefinitions;

  const WordLookupResult({
    required this.word,
    required this.translation,
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

/// Service for translating a single word via free Google Translate, with in-memory LRU cache.
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

  /// Cache key: normalized word (lowercase) + target language.
  static String _cacheKey(String normalizedWord, String targetLang) {
    return '${normalizedWord.toLowerCase()}|$targetLang';
  }

  /// Look up translation for [word]. Uses [targetLang] (e.g. 'ru', 'en', 'tr').
  /// Returns cached result if available; otherwise calls Google Translate and caches.
  Future<WordLookupResult> lookup(String word, String targetLang) async {
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
      _cache.put(key, lookup);
      return lookup;
    } catch (e) {
      final lookup = WordLookupResult(
        word: normalized,
        translation: '',
        errorMessage: e.toString(),
      );
      return lookup;
    }
  }
}
