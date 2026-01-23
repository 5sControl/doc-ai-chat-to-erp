// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_cards_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnowledgeCardsState _$KnowledgeCardsStateFromJson(Map<String, dynamic> json) =>
    KnowledgeCardsState(
      knowledgeCards: (json['knowledgeCards'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => KnowledgeCard.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      extractionStatuses: (json['extractionStatuses'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry(k, $enumDecode(_$KnowledgeCardStatusEnumMap, e)),
          ),
    );

Map<String, dynamic> _$KnowledgeCardsStateToJson(
  KnowledgeCardsState instance,
) => <String, dynamic>{
  'knowledgeCards': instance.knowledgeCards,
  'extractionStatuses': instance.extractionStatuses.map(
    (k, e) => MapEntry(k, _$KnowledgeCardStatusEnumMap[e]!),
  ),
};

const _$KnowledgeCardStatusEnumMap = {
  KnowledgeCardStatus.loading: 'loading',
  KnowledgeCardStatus.complete: 'complete',
  KnowledgeCardStatus.error: 'error',
  KnowledgeCardStatus.initial: 'initial',
  KnowledgeCardStatus.unsupported: 'unsupported',
};
