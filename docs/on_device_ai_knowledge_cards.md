# On-Device AI для генерации Knowledge Cards
## Apple Intelligence & Flutter Альтернативы

## Обзор

Данный документ описывает возможность использования локального AI (on-device) для генерации карточек знаний вместо облачного API. Рассматриваются два основных направления:

1. **Apple Intelligence** (iOS 18+, macOS 15+) - использование Foundation Models от Apple
2. **Flutter-совместимые решения** - кроссплатформенные on-device AI решения

## 1. Apple Intelligence & Foundation Models

### 1.1 Что такое Apple Intelligence?

Apple Intelligence - это набор AI возможностей, встроенных в iOS 18+, iPadOS 18+ и macOS Sequoia 15+. Включает:

- **On-device Foundation Models** - языковые модели, работающие локально
- **Writing Tools** - помощь с текстом
- **Summarization APIs** - встроенные API для суммаризации
- **Privacy-first подход** - все вычисления на устройстве

### 1.2 Системные требования

**Поддерживаемые устройства** (для локального AI):
- iPhone 15 Pro и 15 Pro Max (A17 Pro)
- iPhone 16 (все модели, A18)
- iPad с M1 chip и новее
- Mac с Apple Silicon (M1, M2, M3, M4)

**Минимальные требования ОС**:
- iOS 18.1+
- iPadOS 18.1+
- macOS Sequoia 15.1+

### 1.3 Доступные API

#### 1.3.1 Natural Language Framework

iOS предоставляет встроенный фреймворк для NLP задач:

```swift
import NaturalLanguage

// Извлечение ключевых фраз
let tagger = NLTagger(tagSchemes: [.nameType])
tagger.string = summaryText

// Summarization (iOS 18+)
let summarizer = NLSummarizer()
summarizer.text = summaryText
let summary = summarizer.generateSummary(maxLength: 500)
```

#### 1.3.2 Core ML Models

Можно использовать кастомные модели:

```swift
import CoreML

// Загрузка модели для extraction
let model = try KnowledgeCardExtractor(configuration: MLModelConfiguration())

let prediction = try model.prediction(input: inputText)
let cards = parseKnowledgeCards(from: prediction)
```

### 1.4 Преимущества Apple Intelligence

✅ **Приватность**: Данные не покидают устройство  
✅ **Скорость**: Нет задержки на сетевые запросы  
✅ **Offline работа**: Не требуется интернет  
✅ **Бесплатно**: Нет расходов на API вызовы  
✅ **Интеграция**: Нативная поддержка iOS  

### 1.5 Ограничения Apple Intelligence

❌ **Доступность**: Только новые устройства с мощными чипами  
❌ **iOS only**: Не работает на Android  
❌ **Качество**: Может быть ниже, чем у GPT-4/Claude  
❌ **Кастомизация**: Ограниченные возможности fine-tuning  
❌ **Размер модели**: Ограничен памятью устройства  

## 2. Реализация на iOS с Apple Intelligence

### 2.1 Архитектура решения

```
┌─────────────────────────────────────────┐
│         Flutter Application             │
│  (Dart, cross-platform UI & logic)      │
└──────────────┬──────────────────────────┘
               │
               │ Method Channel
               │
┌──────────────▼──────────────────────────┐
│       iOS Native Module (Swift)         │
│  • Natural Language Framework           │
│  • Core ML Model Integration            │
│  • Knowledge Cards Extraction Logic     │
└──────────────┬──────────────────────────┘
               │
               │
┌──────────────▼──────────────────────────┐
│    Apple Intelligence / Core ML         │
│  • On-device Language Model             │
│  • NLP Processing                       │
│  • Extraction & Classification          │
└─────────────────────────────────────────┘
```

### 2.2 Swift Implementation

**Файл**: `ios/Runner/KnowledgeCardsExtractor.swift`

```swift
import Foundation
import NaturalLanguage
import CoreML

@objc class KnowledgeCardsExtractor: NSObject {
    
    // MARK: - Properties
    private let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
    
    // MARK: - Public Methods
    @objc func extractKnowledgeCards(
        from text: String,
        numCards: Int = 5,
        completion: @escaping ([String: Any]?, Error?) -> Void
    ) {
        // Проверка доступности iOS 18+
        guard #available(iOS 18.0, *) else {
            completion(nil, NSError(
                domain: "KnowledgeCards",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "iOS 18+ required"]
            ))
            return
        }
        
        // Асинхронная обработка
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // Шаг 1: Разбить текст на предложения
                let sentences = self.extractSentences(from: text)
                
                // Шаг 2: Извлечь ключевые концепты и термины
                let keyTerms = self.extractKeyTerms(from: text)
                
                // Шаг 3: Идентифицировать важные предложения
                let importantSentences = self.rankSentences(sentences)
                
                // Шаг 4: Генерация карточек
                let cards = self.generateCards(
                    from: importantSentences,
                    keyTerms: keyTerms,
                    maxCards: numCards
                )
                
                // Шаг 5: Форматирование результата
                let result: [String: Any] = [
                    "cards": cards.map { $0.toDictionary() },
                    "generated_at": ISO8601DateFormatter().string(from: Date()),
                    "total_cards": cards.count
                ]
                
                DispatchQueue.main.async {
                    completion(result, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func extractSentences(from text: String) -> [String] {
        var sentences: [String] = []
        
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            sentences.append(String(text[range]))
            return true
        }
        
        return sentences
    }
    
    private func extractKeyTerms(from text: String) -> [KeyTerm] {
        var terms: [KeyTerm] = []
        
        tagger.string = text
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation]
        
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: options
        ) { tag, range in
            if let tag = tag {
                let term = String(text[range])
                let type = self.mapTagToCardType(tag)
                terms.append(KeyTerm(text: term, type: type))
            }
            return true
        }
        
        return terms
    }
    
    private func rankSentences(_ sentences: [String]) -> [RankedSentence] {
        // Простой алгоритм ранжирования на основе:
        // - Длины предложения
        // - Наличия ключевых слов
        // - Позиции в тексте
        
        return sentences.enumerated().map { index, sentence in
            var score: Double = 0.0
            
            // Длина (оптимальная 15-30 слов)
            let wordCount = sentence.components(separatedBy: .whitespaces).count
            if wordCount >= 15 && wordCount <= 30 {
                score += 0.3
            }
            
            // Ключевые слова
            let keywords = ["important", "key", "main", "essentially", "therefore", "conclude"]
            for keyword in keywords {
                if sentence.lowercased().contains(keyword) {
                    score += 0.2
                }
            }
            
            // Позиция (начало и конец более важны)
            if index < 3 || index >= sentences.count - 3 {
                score += 0.2
            }
            
            return RankedSentence(text: sentence, score: score, position: index)
        }.sorted { $0.score > $1.score }
    }
    
    private func generateCards(
        from sentences: [RankedSentence],
        keyTerms: [KeyTerm],
        maxCards: Int
    ) -> [KnowledgeCard] {
        var cards: [KnowledgeCard] = []
        
        // Генерация Thesis карточек (из топ предложений)
        let thesisCards = sentences.prefix(maxCards / 2).map { sentence in
            KnowledgeCard(
                id: UUID().uuidString,
                type: .thesis,
                title: self.generateTitle(from: sentence.text),
                content: sentence.text,
                explanation: nil,
                relevanceScore: sentence.score
            )
        }
        cards.append(contentsOf: thesisCards)
        
        // Генерация Term карточек (из ключевых терминов)
        let termCards = keyTerms.prefix(maxCards / 4).map { term in
            KnowledgeCard(
                id: UUID().uuidString,
                type: .term,
                title: term.text,
                content: self.generateDefinition(for: term),
                explanation: nil,
                relevanceScore: 0.8
            )
        }
        cards.append(contentsOf: termCards)
        
        // Ограничение по количеству
        return Array(cards.prefix(maxCards))
    }
    
    private func generateTitle(from sentence: String) -> String {
        // Извлечь первые 5-10 слов как title
        let words = sentence.components(separatedBy: .whitespaces)
        let titleWords = words.prefix(min(10, words.count))
        var title = titleWords.joined(separator: " ")
        
        if title.count > 80 {
            title = String(title.prefix(77)) + "..."
        }
        
        return title
    }
    
    private func generateDefinition(for term: KeyTerm) -> String {
        // Найти предложение, содержащее термин и контекст
        // Это упрощенная версия - в реальности нужен более сложный алгоритм
        return "Definition for \(term.text)"
    }
    
    private func mapTagToCardType(_ tag: NLTag) -> KnowledgeCardType {
        switch tag {
        case .personalName, .placeName, .organizationName:
            return .term
        default:
            return .insight
        }
    }
}

// MARK: - Supporting Types

struct KeyTerm {
    let text: String
    let type: KnowledgeCardType
}

struct RankedSentence {
    let text: String
    let score: Double
    let position: Int
}

struct KnowledgeCard {
    let id: String
    let type: KnowledgeCardType
    let title: String
    let content: String
    let explanation: String?
    let relevanceScore: Double
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "type": type.rawValue,
            "title": title,
            "content": content,
            "relevance_score": relevanceScore
        ]
        
        if let explanation = explanation {
            dict["explanation"] = explanation
        }
        
        return dict
    }
}

enum KnowledgeCardType: String {
    case thesis
    case term
    case conclusion
    case insight
}
```

### 2.3 Flutter Integration (Method Channel)

**Файл**: `lib/services/on_device_knowledge_cards.dart`

```dart
import 'package:flutter/services.dart';
import 'package:summify/models/models.dart';

class OnDeviceKnowledgeCardsService {
  static const MethodChannel _channel = MethodChannel('knowledge_cards_extractor');
  
  /// Проверка доступности on-device AI
  Future<bool> isAvailable() async {
    try {
      final bool available = await _channel.invokeMethod('isAvailable');
      return available;
    } catch (e) {
      return false;
    }
  }
  
  /// Извлечение карточек локально (без API)
  Future<List<KnowledgeCard>> extractKnowledgeCards(
    String summaryText, {
    int numCards = 5,
  }) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'extractKnowledgeCards',
        {
          'text': summaryText,
          'numCards': numCards,
        },
      );
      
      final List<dynamic> cardsData = result['cards'] as List<dynamic>;
      
      return cardsData.map((cardData) {
        final card = cardData as Map<dynamic, dynamic>;
        return KnowledgeCard(
          id: card['id'] as String,
          type: _parseCardType(card['type'] as String),
          title: card['title'] as String,
          content: card['content'] as String,
          explanation: card['explanation'] as String?,
          isSaved: false,
          extractedAt: DateTime.now(),
        );
      }).toList();
      
    } on PlatformException catch (e) {
      throw Exception('Failed to extract knowledge cards: ${e.message}');
    }
  }
  
  KnowledgeCardType _parseCardType(String typeString) {
    return KnowledgeCardType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => KnowledgeCardType.insight,
    );
  }
}
```

**Файл**: `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let knowledgeCardsExtractor = KnowledgeCardsExtractor()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "knowledge_cards_extractor",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            switch call.method {
            case "isAvailable":
                if #available(iOS 18.0, *) {
                    result(true)
                } else {
                    result(false)
                }
                
            case "extractKnowledgeCards":
                guard let args = call.arguments as? [String: Any],
                      let text = args["text"] as? String else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Text parameter required",
                        details: nil
                    ))
                    return
                }
                
                let numCards = args["numCards"] as? Int ?? 5
                
                self.knowledgeCardsExtractor.extractKnowledgeCards(
                    from: text,
                    numCards: numCards
                ) { cards, error in
                    if let error = error {
                        result(FlutterError(
                            code: "EXTRACTION_ERROR",
                            message: error.localizedDescription,
                            details: nil
                        ))
                    } else {
                        result(cards)
                    }
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

### 2.4 Использование в приложении

**Обновленный BLoC**: `lib/bloc/knowledge_cards/knowledge_cards_bloc.dart`

```dart
Future<void> _onExtractKnowledgeCards(
  ExtractKnowledgeCards event,
  Emitter<KnowledgeCardsState> emit,
) async {
  emit(state.copyWith(
    extractionStatuses: {
      ...state.extractionStatuses,
      event.summaryKey: KnowledgeCardStatus.loading,
    },
  ));

  try {
    List<KnowledgeCard> cards;
    
    // Попробовать использовать on-device AI сначала
    final onDeviceService = OnDeviceKnowledgeCardsService();
    final isOnDeviceAvailable = await onDeviceService.isAvailable();
    
    if (isOnDeviceAvailable) {
      // Использовать локальный AI
      cards = await onDeviceService.extractKnowledgeCards(event.summaryText);
      
      mixpanelBloc.add(KnowledgeCardsExtractedLocally(
        summaryKey: event.summaryKey,
        cardsCount: cards.length,
      ));
    } else {
      // Fallback на облачный API
      cards = await summaryRepository.extractKnowledgeCards(event.summaryText);
      
      mixpanelBloc.add(KnowledgeCardsExtractedFromAPI(
        summaryKey: event.summaryKey,
        cardsCount: cards.length,
      ));
    }

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: cards,
      },
      extractionStatuses: {
        ...state.extractionStatuses,
        event.summaryKey: KnowledgeCardStatus.complete,
      },
    ));

  } catch (error) {
    emit(state.copyWith(
      extractionStatuses: {
        ...state.extractionStatuses,
        event.summaryKey: KnowledgeCardStatus.error,
      },
    ));

    mixpanelBloc.add(KnowledgeCardsExtractionError(
      summaryKey: event.summaryKey,
      error: error.toString(),
    ));
  }
}
```

## 3. Кроссплатформенные Flutter решения

### 3.1 Google ML Kit (Flutter)

**Пакет**: `google_ml_kit`

```yaml
dependencies:
  google_ml_kit: ^0.16.0
```

**Возможности**:
- Распознавание текста
- Языковая идентификация
- Entity extraction (limited)
- **Ограничение**: Нет полноценной генерации карточек

### 3.2 TensorFlow Lite Flutter

**Пакет**: `tflite_flutter`

```yaml
dependencies:
  tflite_flutter: ^0.10.0
```

**Подход**:
1. Обучить custom модель для extraction
2. Конвертировать в TFLite формат
3. Загрузить в приложение
4. Использовать для inference

**Пример**:
```dart
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteKnowledgeExtractor {
  Interpreter? _interpreter;
  
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('knowledge_extractor.tflite');
  }
  
  Future<List<KnowledgeCard>> extract(String text) async {
    // Preprocessing
    final input = preprocessText(text);
    
    // Run inference
    final output = List.filled(_interpreter!.getOutputTensor(0).shape[1], 0.0)
        .reshape([1, _interpreter!.getOutputTensor(0).shape[1]]);
    
    _interpreter!.run(input, output);
    
    // Postprocessing
    return parseOutput(output);
  }
}
```

### 3.3 On-Device LLM (llama.cpp Flutter)

**Пакет**: `llama_cpp_dart` или custom implementation

**Подход**:
- Использовать квантизированные модели (Llama 3, Phi-3)
- Размер модели: 1-4GB (для мобильных устройств)
- Работает полностью offline

**Ограничения**:
- Требует много памяти (минимум 6GB RAM)
- Медленно на старых устройствах
- Большой размер приложения

### 3.4 Comparison Matrix

| Решение | iOS | Android | Качество | Скорость | Сложность реализации |
|---------|-----|---------|----------|----------|---------------------|
| Apple Intelligence | ✅ (iOS 18+) | ❌ | ⭐⭐⭐⭐ | ⚡⚡⚡ | 🔧🔧 |
| Google ML Kit | ✅ | ✅ | ⭐⭐ | ⚡⚡⚡ | 🔧 |
| TensorFlow Lite | ✅ | ✅ | ⭐⭐⭐ | ⚡⚡ | 🔧🔧🔧 |
| On-Device LLM | ✅ | ✅ | ⭐⭐⭐⭐⭐ | ⚡ | 🔧🔧🔧🔧 |
| Cloud API | ✅ | ✅ | ⭐⭐⭐⭐⭐ | ⚡⚡ | 🔧 |

## 4. Рекомендации по реализации

### 4.1 Гибридный подход (Recommended)

```dart
class KnowledgeCardsService {
  final OnDeviceKnowledgeCardsService _onDevice;
  final SummaryRepository _cloudAPI;
  
  Future<List<KnowledgeCard>> extractKnowledgeCards(
    String summaryText, {
    bool preferOnDevice = true,
  }) async {
    // Стратегия 1: On-device first (если доступно)
    if (preferOnDevice) {
      final isAvailable = await _onDevice.isAvailable();
      if (isAvailable) {
        try {
          return await _onDevice.extractKnowledgeCards(summaryText);
        } catch (e) {
          // Fallback на облако при ошибке
          return await _cloudAPI.extractKnowledgeCards(summaryText);
        }
      }
    }
    
    // Стратегия 2: Cloud API (fallback или предпочтение пользователя)
    return await _cloudAPI.extractKnowledgeCards(summaryText);
  }
}
```

### 4.2 User Settings

Дать пользователю выбор:

```dart
enum ExtractionMode {
  auto,        // Автоматический выбор (on-device если доступно)
  onDevice,    // Только локально (быстрее, приватнее)
  cloud,       // Только облако (лучше качество)
}

class UserSettings {
  ExtractionMode knowledgeCardsMode = ExtractionMode.auto;
}
```

### 4.3 Quality Assurance

Отслеживать качество локальной генерации:

```dart
class KnowledgeCardsQualityTracker {
  void trackExtraction({
    required String source, // 'on_device' or 'cloud'
    required int cardsCount,
    required List<bool> userSavedCards,
  }) {
    final saveRate = userSavedCards.where((saved) => saved).length / cardsCount;
    
    // Если save rate низкий для on-device, переключить на cloud
    if (source == 'on_device' && saveRate < 0.3) {
      // Suggest user to switch to cloud mode
    }
  }
}
```

## 5. Roadmap реализации

### Фаза 1: Исследование (2 недели)
- [ ] Тестирование Apple Intelligence API на iOS 18+
- [ ] Оценка качества генерации vs Cloud API
- [ ] Benchmark производительности на разных устройствах
- [ ] Исследование альтернатив для Android

### Фаза 2: Proof of Concept (3 недели)
- [ ] Реализация базового Swift модуля для iOS
- [ ] Method Channel интеграция с Flutter
- [ ] Простой алгоритм extraction без ML
- [ ] A/B тестирование качества

### Фаза 3: Production Ready (4 недели)
- [ ] Улучшение алгоритма extraction
- [ ] Добавление Core ML модели (опционально)
- [ ] Fallback механизм на Cloud API
- [ ] Extensive testing на разных устройствах
- [ ] User settings для выбора режима

### Фаза 4: Android Support (6 недель)
- [ ] Исследование лучшего подхода для Android
- [ ] Реализация Kotlin модуля
- [ ] TensorFlow Lite integration (если нужно)
- [ ] Кроссплатформенное тестирование

## 6. Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Низкое качество on-device | 🔴 High | Fallback на Cloud API, A/B testing |
| Ограниченная доступность (iOS 18+) | 🟡 Medium | Гибридный подход, graceful degradation |
| Производительность на старых устройствах | 🟡 Medium | Device capabilities check, timeout |
| Большой размер Core ML модели | 🟡 Medium | On-demand download, optional feature |
| Сложность поддержки двух систем | 🟢 Low | Хорошая архитектура, unit tests |

## 7. Заключение

### Рекомендуемый подход:

1. **Для iOS 18+**: Реализовать on-device extraction с помощью Natural Language Framework
2. **Для остальных**: Использовать существующий Cloud API
3. **Стратегия**: Гибридный подход с автоматическим выбором
4. **Timeline**: 2-3 месяца для полной реализации

### Приоритеты:

✅ **Сделать сейчас**:
- Proof of Concept для iOS 18+
- Benchmark качества vs Cloud API

⏸️ **Отложить**:
- Полноценная Android поддержка
- Custom ML модели

❌ **Не делать**:
- On-device LLM (слишком сложно для MVP)
- Полная замена Cloud API (риск качества)

---

**Версия документа**: 1.0  
**Дата**: 21.01.2026  
**Статус**: Technical Specification
