import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/saved_cards/saved_cards_bloc.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/demo_knowledge_cards.dart';
import 'package:summify/services/summaryApi.dart';

part 'knowledge_cards_event.dart';
part 'knowledge_cards_state.dart';
part 'knowledge_cards_bloc.g.dart';

/// Separator for composite card id (summaryKey + backend card id).
/// Ensures saved state is per-document.
const String _kCardIdSeparator = '::';

class KnowledgeCardsBloc extends HydratedBloc<KnowledgeCardsEvent, KnowledgeCardsState> {
  final MixpanelBloc mixpanelBloc;
  final SavedCardsBloc savedCardsBloc;

  KnowledgeCardsBloc({
    required this.mixpanelBloc,
    required this.savedCardsBloc,
  })
      : super(const KnowledgeCardsState(
          knowledgeCards: {},
          extractionStatuses: {},
        )) {
    on<ExtractKnowledgeCards>(_onExtractKnowledgeCards);
    on<SaveKnowledgeCard>(_onSaveKnowledgeCard);
    on<UnsaveKnowledgeCard>(_onUnsaveKnowledgeCard);
    on<ClearKnowledgeCards>(_onClearKnowledgeCards);
    on<SyncCardsWithSaved>(_onSyncCardsWithSaved);
    on<InitializeDemoCards>(_onInitializeDemoCards);
    
    // Initialize demo cards on first launch (same pattern as demo summary)
    add(const InitializeDemoCards());
  }

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

    List<KnowledgeCard> extractedCards;

    try {
      final rawCards = await SummaryRepository().extractKnowledgeCards(event.summaryText);
      // Composite id so saved state is per-document (backend returns card_1, card_2 for every doc).
      extractedCards = rawCards
          .map((card) => card.copyWith(id: '${event.summaryKey}$_kCardIdSeparator${card.id}'))
          .toList();
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
      return;
    }

    final savedCardsMap = savedCardsBloc.state.savedCards;
    final syncedCards = extractedCards.map((card) {
      final isSaved = savedCardsMap.containsKey(card.id);
      if (isSaved) {
        final savedCard = savedCardsMap[card.id]!;
        return card.copyWith(
          isSaved: true,
          sourceSummaryKey: savedCard.sourceSummaryKey,
          sourceTitle: savedCard.sourceTitle,
          savedAt: savedCard.savedAt,
        );
      }
      return card;
    }).toList();

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: syncedCards,
      },
      extractionStatuses: {
        ...state.extractionStatuses,
        event.summaryKey: KnowledgeCardStatus.complete,
      },
    ));

    mixpanelBloc.add(KnowledgeCardsExtracted(
      summaryKey: event.summaryKey,
      cardsCount: syncedCards.length,
    ));
  }

  void _onSaveKnowledgeCard(
    SaveKnowledgeCard event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    final currentCards = state.knowledgeCards[event.summaryKey];
    if (currentCards == null) return;

    KnowledgeCard? cardToSave;
    final updatedCards = currentCards.map((card) {
      if (card.id == event.cardId) {
        final savedCard = card.copyWith(
          isSaved: true,
          sourceSummaryKey: event.summaryKey,
          sourceTitle: event.sourceTitle,
          savedAt: DateTime.now(),
        );
        cardToSave = savedCard;
        return savedCard;
      }
      return card;
    }).toList();

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: updatedCards,
      },
    ));

    // Add to global saved cards
    if (cardToSave != null) {
      savedCardsBloc.add(AddSavedCard(card: cardToSave!));
    }

    // Track analytics
    mixpanelBloc.add(KnowledgeCardSaved(
      summaryKey: event.summaryKey,
      cardId: event.cardId,
    ));
  }

  void _onUnsaveKnowledgeCard(
    UnsaveKnowledgeCard event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    final currentCards = state.knowledgeCards[event.summaryKey];
    if (currentCards == null) return;

    final updatedCards = currentCards.map((card) {
      if (card.id == event.cardId) {
        return card.copyWith(isSaved: false);
      }
      return card;
    }).toList();

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: updatedCards,
      },
    ));

    // Remove from global saved cards
    savedCardsBloc.add(RemoveSavedCard(cardId: event.cardId));

    // Track analytics
    mixpanelBloc.add(KnowledgeCardUnsaved(
      summaryKey: event.summaryKey,
      cardId: event.cardId,
    ));
  }

  void _onClearKnowledgeCards(
    ClearKnowledgeCards event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    final updatedCards = {...state.knowledgeCards};
    updatedCards.remove(event.summaryKey);

    final updatedStatuses = {...state.extractionStatuses};
    updatedStatuses.remove(event.summaryKey);

    emit(state.copyWith(
      knowledgeCards: updatedCards,
      extractionStatuses: updatedStatuses,
    ));
  }

  void _onSyncCardsWithSaved(
    SyncCardsWithSaved event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    final currentCards = state.knowledgeCards[event.summaryKey];
    if (currentCards == null || currentCards.isEmpty) {
      return;
    }

    // Get all saved cards
    final savedCardsMap = savedCardsBloc.state.savedCards;

    // Sync each card's saved status
    final syncedCards = currentCards.map((card) {
      final isSaved = savedCardsMap.containsKey(card.id);
      if (isSaved) {
        final savedCard = savedCardsMap[card.id]!;
        return card.copyWith(
          isSaved: true,
          sourceSummaryKey: savedCard.sourceSummaryKey,
          sourceTitle: savedCard.sourceTitle,
          savedAt: savedCard.savedAt,
        );
      } else {
        return card.copyWith(isSaved: false);
      }
    }).toList();

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: syncedCards,
      },
    ));
  }

  void _onInitializeDemoCards(
    InitializeDemoCards event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    // Check if demo cards already exist
    if (state.knowledgeCards.containsKey(DemoKnowledgeCards.demoKey)) {
      return;
    }

    // Get pre-generated demo cards and assign composite ids for consistency
    final rawDemoCards = DemoKnowledgeCards.getDemoCards();
    final demoCards = rawDemoCards
        .map((card) =>
            card.copyWith(id: '${DemoKnowledgeCards.demoKey}$_kCardIdSeparator${card.id}'))
        .toList();

    // Add demo cards to state
    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        DemoKnowledgeCards.demoKey: demoCards,
      },
      extractionStatuses: {
        ...state.extractionStatuses,
        DemoKnowledgeCards.demoKey: KnowledgeCardStatus.complete,
      },
    ));
  }

  @override
  KnowledgeCardsState? fromJson(Map<String, dynamic> json) =>
      KnowledgeCardsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(KnowledgeCardsState state) => state.toJson();
}