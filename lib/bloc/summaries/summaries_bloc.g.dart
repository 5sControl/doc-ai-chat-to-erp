// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summaries_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummariesState _$SummariesStateFromJson(Map<String, dynamic> json) =>
    SummariesState(
      summaries: (json['summaries'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, SummaryData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SummariesStateToJson(SummariesState instance) =>
    <String, dynamic>{
      'summaries': instance.summaries,
    };
