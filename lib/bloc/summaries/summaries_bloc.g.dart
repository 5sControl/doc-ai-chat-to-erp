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
      textCounter: json['textCounter'] as int,
      defaultSummaryType:
          $enumDecode(_$SummaryTypeEnumMap, json['defaultSummaryType']),
      freeSummaries: json['freeSummaries'] as int,
    );

Map<String, dynamic> _$SummariesStateToJson(SummariesState instance) =>
    <String, dynamic>{
      'summaries': instance.summaries,
      'ratedSummaries': instance.ratedSummaries.toList(),
      'textCounter': instance.textCounter,
      'defaultSummaryType': _$SummaryTypeEnumMap[instance.defaultSummaryType]!,
      'freeSummaries': instance.freeSummaries,
    };

const _$SummaryTypeEnumMap = {
  SummaryType.long: 'long',
  SummaryType.short: 'short',
};
