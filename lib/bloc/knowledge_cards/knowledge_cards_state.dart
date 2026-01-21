part of 'knowledge_cards_bloc.dart';

@JsonSerializable()
class KnowledgeCardsState extends Equatable {
  final Map<String, List<KnowledgeCard>> knowledgeCards;
  final Map<String, KnowledgeCardStatus> extractionStatuses;

  const KnowledgeCardsState({
    required this.knowledgeCards,
    required this.extractionStatuses,
  });

  KnowledgeCardsState copyWith({
    Map<String, List<KnowledgeCard>>? knowledgeCards,
    Map<String, KnowledgeCardStatus>? extractionStatuses,
  }) {
    return KnowledgeCardsState(
      knowledgeCards: knowledgeCards ?? this.knowledgeCards,
      extractionStatuses: extractionStatuses ?? this.extractionStatuses,
    );
  }

  factory KnowledgeCardsState.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeCardsStateFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeCardsStateToJson(this);

  @override
  List<Object?> get props => [knowledgeCards, extractionStatuses];
}