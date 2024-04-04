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
      ratedSummaries: (json['ratedSummaries'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      dailyLimit: json['dailyLimit'] as int,
      dailySummariesMap:
          Map<String, int>.from(json['dailySummariesMap'] as Map),
      textCounter: json['textCounter'] as int,
    );

Map<String, dynamic> _$SummariesStateToJson(SummariesState instance) =>
    <String, dynamic>{
      'summaries': instance.summaries,
      'ratedSummaries': instance.ratedSummaries.toList(),
      'dailyLimit': instance.dailyLimit,
      'dailySummariesMap': instance.dailySummariesMap,
      'textCounter': instance.textCounter,
    };
