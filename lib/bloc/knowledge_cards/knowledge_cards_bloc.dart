import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/models/models.dart';
import 'package:summify/services/summaryApi.dart';

part 'knowledge_cards_event.dart';
part 'knowledge_cards_state.dart';
part 'knowledge_cards_bloc.g.dart';

class KnowledgeCardsBloc extends HydratedBloc<KnowledgeCardsEvent, KnowledgeCardsState> {
  final MixpanelBloc mixpanelBloc;
  final SummaryRepository summaryRepository = SummaryRepository();

  KnowledgeCardsBloc({required this.mixpanelBloc})
      : super(const KnowledgeCardsState(
          knowledgeCards: {},
          extractionStatuses: {},
        )) {
    on<ExtractKnowledgeCards>(_onExtractKnowledgeCards);
    on<SaveKnowledgeCard>(_onSaveKnowledgeCard);
    on<UnsaveKnowledgeCard>(_onUnsaveKnowledgeCard);
    on<ClearKnowledgeCards>(_onClearKnowledgeCards);
  }

  Future<void> _onExtractKnowledgeCards(
    ExtractKnowledgeCards event,
    Emitter<KnowledgeCardsState> emit,
  ) async {
    // Set loading status
    emit(state.copyWith(
      extractionStatuses: {
        ...state.extractionStatuses,
        event.summaryKey: KnowledgeCardStatus.loading,
      },
    ));

    try {
      // Call API to extract knowledge cards
      final cards = await summaryRepository.extractKnowledgeCards(event.summaryText);

      // Update state with extracted cards
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

      // Track analytics
      mixpanelBloc.add(KnowledgeCardsExtracted(
        summaryKey: event.summaryKey,
        cardsCount: cards.length,
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

    final updatedCards = currentCards.map((card) {
      if (card.id == event.cardId) {
        return card.copyWith(isSaved: true);
      }
      return card;
    }).toList();

    emit(state.copyWith(
      knowledgeCards: {
        ...state.knowledgeCards,
        event.summaryKey: updatedCards,
      },
    ));

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

  @override
  KnowledgeCardsState? fromJson(Map<String, dynamic> json) =>
      KnowledgeCardsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(KnowledgeCardsState state) => state.toJson();
}