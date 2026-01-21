import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:summify/models/models.dart';

part 'saved_cards_event.dart';
part 'saved_cards_state.dart';
part 'saved_cards_bloc.g.dart';

class SavedCardsBloc extends HydratedBloc<SavedCardsEvent, SavedCardsState> {
  SavedCardsBloc()
      : super(const SavedCardsState(
          savedCards: {},
        )) {
    on<AddSavedCard>(_onAddSavedCard);
    on<RemoveSavedCard>(_onRemoveSavedCard);
    on<ClearAllSavedCards>(_onClearAllSavedCards);
  }

  void _onAddSavedCard(
    AddSavedCard event,
    Emitter<SavedCardsState> emit,
  ) {
    final updatedCards = Map<String, KnowledgeCard>.from(state.savedCards);
    
    // Add card with savedAt timestamp
    final cardToSave = event.card.copyWith(
      isSaved: true,
      savedAt: DateTime.now(),
    );
    
    updatedCards[event.card.id] = cardToSave;

    emit(state.copyWith(savedCards: updatedCards));
  }

  void _onRemoveSavedCard(
    RemoveSavedCard event,
    Emitter<SavedCardsState> emit,
  ) {
    final updatedCards = Map<String, KnowledgeCard>.from(state.savedCards);
    updatedCards.remove(event.cardId);

    emit(state.copyWith(savedCards: updatedCards));
  }

  void _onClearAllSavedCards(
    ClearAllSavedCards event,
    Emitter<SavedCardsState> emit,
  ) {
    emit(state.copyWith(savedCards: {}));
  }

  @override
  SavedCardsState? fromJson(Map<String, dynamic> json) {
    try {
      return SavedCardsState.fromJson(json);
    } catch (e) {
      // If deserialization fails, return initial state
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SavedCardsState state) {
    try {
      return state.toJson();
    } catch (e) {
      // If serialization fails, return null
      return null;
    }
  }
}
