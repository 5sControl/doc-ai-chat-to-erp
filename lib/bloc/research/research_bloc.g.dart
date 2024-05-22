// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResearchState _$ResearchStateFromJson(Map<String, dynamic> json) =>
    ResearchState(
      questions: (json['questions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map(
                    (e) => ResearchQuestion.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ResearchStateToJson(ResearchState instance) =>
    <String, dynamic>{
      'questions': instance.questions,
    };
