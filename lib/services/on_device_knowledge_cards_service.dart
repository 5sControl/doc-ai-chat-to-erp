import 'dart:io';
import 'package:flutter/services.dart';
import 'package:summify/models/models.dart';

class OnDeviceKnowledgeCardsService {
  static const MethodChannel _channel = MethodChannel('knowledge_cards_extractor');
  
  /// Check if Apple Intelligence is available on current device
  Future<bool> isAvailable() async {
    try {
      // On Android, always return false
      if (!Platform.isIOS) {
        return false;
      }
      
      final bool available = await _channel.invokeMethod('isAppleIntelligenceAvailable');
      return available;
    } catch (e) {
      print('🧠 OnDeviceKnowledgeCardsService: Error checking availability - $e');
      return false;
    }
  }
  
  /// Get detailed device information
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      // On Android, return default unsupported info
      if (!Platform.isIOS) {
        return const DeviceInfo(
          supportsAppleIntelligence: false,
          deviceModel: 'Android Device',
          osVersion: 'N/A',
          unsupportedReason: 'Apple Intelligence is only available on iOS devices',
        );
      }
      
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getDeviceInfo');
      
      return DeviceInfo(
        supportsAppleIntelligence: result['supportsAppleIntelligence'] as bool,
        deviceModel: result['deviceModel'] as String,
        osVersion: result['osVersion'] as String,
        unsupportedReason: result['unsupportedReason'] as String?,
      );
    } catch (e) {
      print('🧠 OnDeviceKnowledgeCardsService: Error getting device info - $e');
      return const DeviceInfo(
        supportsAppleIntelligence: false,
        deviceModel: 'Unknown',
        osVersion: 'Unknown',
        unsupportedReason: 'Error retrieving device information',
      );
    }
  }
  
  /// Calculate optimal number of cards based on text length
  int _calculateOptimalCardCount(String text) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    
    // Base calculation: 1 card per ~200 words
    // Minimum: 5 cards, Maximum: 30 cards
    if (wordCount < 500) {
      return 5; // Short text: 5 cards
    } else if (wordCount < 1000) {
      return 8; // Medium text: 8 cards
    } else if (wordCount < 2000) {
      return 12; // Long text: 12 cards
    } else if (wordCount < 3000) {
      return 15; // Very long text: 15 cards
    } else if (wordCount < 5000) {
      return 20; // Extra long text: 20 cards
    } else {
      return 30; // Maximum for very large texts
    }
  }

  /// Extract knowledge cards locally using Apple Intelligence
  Future<List<KnowledgeCard>> extractKnowledgeCards(
    String summaryText, {
    int? numCards,
  }) async {
    try {
      if (!Platform.isIOS) {
        throw Exception('Apple Intelligence is only available on iOS devices');
      }
      
      // Auto-calculate optimal card count if not specified
      final cardCount = numCards ?? _calculateOptimalCardCount(summaryText);
      
      print('🧠 KnowledgeCards: Text length: ${summaryText.length} chars, generating $cardCount cards');
      
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'extractKnowledgeCards',
        {
          'text': summaryText,
          'numCards': cardCount,
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
      print('🧠 OnDeviceKnowledgeCardsService: Platform exception - ${e.message}');
      throw Exception('Failed to extract knowledge cards: ${e.message}');
    } catch (e) {
      print('🧠 OnDeviceKnowledgeCardsService: Error - $e');
      throw Exception('Failed to extract knowledge cards: $e');
    }
  }
  
  KnowledgeCardType _parseCardType(String typeString) {
    return KnowledgeCardType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => KnowledgeCardType.insight,
    );
  }
}
