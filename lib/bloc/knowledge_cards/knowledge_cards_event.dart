part of 'knowledge_cards_bloc.dart';

sealed class KnowledgeCardsEvent extends Equatable {
  const KnowledgeCardsEvent();
}

class ExtractKnowledgeCards extends KnowledgeCardsEvent {
  final String summaryKey;
  final String summaryText;

  const ExtractKnowledgeCards({
    required this.summaryKey,
    required this.summaryText,
  });

  @override
  List<Object?> get props => [summaryKey, summaryText];
}

class SaveKnowledgeCard extends KnowledgeCardsEvent {
  final String summaryKey;
  final String cardId;
  final String? sourceTitle;
  /// Server document UUID. When set, also syncs save state via v2 API.
  final String? documentServerId;

  const SaveKnowledgeCard({
    required this.summaryKey,
    required this.cardId,
    this.sourceTitle,
    this.documentServerId,
  });

  @override
  List<Object?> get props => [summaryKey, cardId, sourceTitle, documentServerId];
}

class UnsaveKnowledgeCard extends KnowledgeCardsEvent {
  final String summaryKey;
  final String cardId;
  final String? documentServerId;

  const UnsaveKnowledgeCard({
    required this.summaryKey,
    required this.cardId,
    this.documentServerId,
  });

  @override
  List<Object?> get props => [summaryKey, cardId, documentServerId];
}

class ClearKnowledgeCards extends KnowledgeCardsEvent {
  final String summaryKey;

  const ClearKnowledgeCards({required this.summaryKey});

  @override
  List<Object?> get props => [summaryKey];
}

class SyncCardsWithSaved extends KnowledgeCardsEvent {
  final String summaryKey;

  const SyncCardsWithSaved({required this.summaryKey});

  @override
  List<Object?> get props => [summaryKey];
}

class InitializeDemoCards extends KnowledgeCardsEvent {
  const InitializeDemoCards();

  @override
  List<Object?> get props => [];
}