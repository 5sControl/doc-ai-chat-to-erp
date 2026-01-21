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

  const SaveKnowledgeCard({
    required this.summaryKey,
    required this.cardId,
    this.sourceTitle,
  });

  @override
  List<Object?> get props => [summaryKey, cardId, sourceTitle];
}

class UnsaveKnowledgeCard extends KnowledgeCardsEvent {
  final String summaryKey;
  final String cardId;

  const UnsaveKnowledgeCard({
    required this.summaryKey,
    required this.cardId,
  });

  @override
  List<Object?> get props => [summaryKey, cardId];
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