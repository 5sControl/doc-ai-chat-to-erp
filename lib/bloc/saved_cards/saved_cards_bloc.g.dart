// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_cards_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedCardsState _$SavedCardsStateFromJson(Map<String, dynamic> json) =>
    SavedCardsState(
      savedCards: (json['savedCards'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, KnowledgeCard.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SavedCardsStateToJson(SavedCardsState instance) =>
    <String, dynamic>{'savedCards': instance.savedCards};
