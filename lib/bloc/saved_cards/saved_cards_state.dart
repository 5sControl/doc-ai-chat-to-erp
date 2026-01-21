part of 'saved_cards_bloc.dart';

@JsonSerializable()
class SavedCardsState extends Equatable {
  final Map<String, KnowledgeCard> savedCards;

  const SavedCardsState({
    required this.savedCards,
  });

  SavedCardsState copyWith({
    Map<String, KnowledgeCard>? savedCards,
  }) {
    return SavedCardsState(
      savedCards: savedCards ?? this.savedCards,
    );
  }

  /// Get all saved cards sorted by savedAt (newest first)
  List<KnowledgeCard> get allCardsSorted {
    final cards = savedCards.values.toList();
    cards.sort((a, b) {
      final aTime = a.savedAt ?? a.extractedAt;
      final bTime = b.savedAt ?? b.extractedAt;
      return bTime.compareTo(aTime); // Descending order (newest first)
    });
    return cards;
  }

  /// Get count of saved cards
  int get count => savedCards.length;

  factory SavedCardsState.fromJson(Map<String, dynamic> json) =>
      _$SavedCardsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SavedCardsStateToJson(this);

  @override
  List<Object?> get props => [savedCards];
}
