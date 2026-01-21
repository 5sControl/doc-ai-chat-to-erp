part of 'saved_cards_bloc.dart';

sealed class SavedCardsEvent extends Equatable {
  const SavedCardsEvent();
}

class AddSavedCard extends SavedCardsEvent {
  final KnowledgeCard card;

  const AddSavedCard({required this.card});

  @override
  List<Object?> get props => [card];
}

class RemoveSavedCard extends SavedCardsEvent {
  final String cardId;

  const RemoveSavedCard({required this.cardId});

  @override
  List<Object?> get props => [cardId];
}

class ClearAllSavedCards extends SavedCardsEvent {
  const ClearAllSavedCards();

  @override
  List<Object?> get props => [];
}
