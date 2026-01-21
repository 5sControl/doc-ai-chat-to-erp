import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/saved_cards/saved_cards_bloc.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/on_device_knowledge_cards_service.dart';

part 'knowledge_cards_event.dart';
part 'knowledge_cards_state.dart';
part 'knowledge_cards_bloc.g.dart';

class KnowledgeCardsBloc extends HydratedBloc<KnowledgeCardsEvent, KnowledgeCardsState> {
  final MixpanelBloc mixpanelBloc;
  final SavedCardsBloc savedCardsBloc;
  final OnDeviceKnowledgeCardsService onDeviceService = OnDeviceKnowledgeCardsService();

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
  }

  Future<void> _onExtractKnowledgeCards(
    ExtractKnowledgeCards event,
    Emitter<KnowledgeCardsState> emit,
  ) async {
    // Check if Apple Intelligence is available
    final isAvailable = await onDeviceService.isAvailable();
    
    if (!isAvailable) {
      // Device not supported - show placeholder
      emit(state.copyWith(
        extractionStatuses: {
          ...state.extractionStatuses,
          event.summaryKey: KnowledgeCardStatus.unsupported,
        },
      ));
      
      // Track analytics
      mixpanelBloc.add(KnowledgeCardsUnsupportedDevice(
        summaryKey: event.summaryKey,
      ));
      
      return;
    }

    // Set loading status
    emit(state.copyWith(
      extractionStatuses: {
        ...state.extractionStatuses,
        event.summaryKey: KnowledgeCardStatus.loading,
      },
    ));

    try {
      // Use on-device Apple Intelligence to extract knowledge cards
      final extractedCards = await onDeviceService.extractKnowledgeCards(event.summaryText);

      // Sync with saved cards - mark cards as saved if they exist in SavedCardsBloc
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

      // Update state with extracted cards
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

      // Track analytics
      mixpanelBloc.add(KnowledgeCardsAppleIntelligenceUsed(
        summaryKey: event.summaryKey,
        cardsCount: syncedCards.length,
      ));
    } catch (error) {
      // Set error status
      emit(state.copyWith(
        extractionStatuses: {
          ...state.extractionStatuses,
          event.summaryKey: KnowledgeCardStatus.error,
        },
      ));

      // Track error analytics
      mixpanelBloc.add(KnowledgeCardsExtractionError(
        summaryKey: event.summaryKey,
        error: error.toString(),
      ));
    }
  }

  void _onSaveKnowledgeCard(
    SaveKnowledgeCard event,
    Emitter<KnowledgeCardsState> emit,
  ) {
    final currentCards = state.knowledgeCards[event.summaryKey];
    if (currentCards == null) return;

    print('💾 Save: Saving card ${event.cardId} from ${event.summaryKey}');

    KnowledgeCard? cardToSave;
    final updatedCards = currentCards.map((card) {
      if (card.id == event.cardId) {
        print('💾 Save: Found card to save - ${card.title}');
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
      print('💾 Save: Adding card to SavedCardsBloc - ID: ${cardToSave!.id}');
      savedCardsBloc.add(AddSavedCard(card: cardToSave!));
      print('💾 Save: Total saved cards now: ${savedCardsBloc.state.savedCards.length}');
    } else {
      print('💾 Save: ERROR - cardToSave is null!');
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
      print('🔄 Sync: No cards to sync for ${event.summaryKey}');
      return;
    }

    // Get all saved cards
    final savedCardsMap = savedCardsBloc.state.savedCards;
    
    print('🔄 Sync: Current cards count: ${currentCards.length}');
    print('🔄 Sync: Saved cards count: ${savedCardsMap.length}');
    print('🔄 Sync: Current card IDs: ${currentCards.map((c) => c.id).toList()}');
    print('🔄 Sync: Saved card IDs: ${savedCardsMap.keys.toList()}');

    // Sync each card's saved status
    int syncedCount = 0;
    final syncedCards = currentCards.map((card) {
      final isSaved = savedCardsMap.containsKey(card.id);
      if (isSaved) {
        syncedCount++;
        print('🔄 Sync: Card ${card.id} is SAVED, syncing...');
        final savedCard = savedCardsMap[card.id]!;
        return card.copyWith(
          isSaved: true,
          sourceSummaryKey: savedCard.sourceSummaryKey,
          sourceTitle: savedCard.sourceTitle,
          savedAt: savedCard.savedAt,
        );
      } else {
        print('🔄 Sync: Card ${card.id} is NOT saved');
        // If card was unsaved, update its status
        return card.copyWith(isSaved: false);
      }
    }).toList();

    print('🔄 Sync: Synced $syncedCount cards as saved');

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: syncedCards,
      },
    ));
  }

  @override
  KnowledgeCardsState? fromJson(Map<String, dynamic> json) =>
      KnowledgeCardsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(KnowledgeCardsState state) => state.toJson();
}