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
      ratedSummaries:
          (json['ratedSummaries'] as List<dynamic>)
              .map((e) => e as String)
              .toSet(),
      textCounter: (json['textCounter'] as num).toInt(),
      defaultSummaryType: $enumDecode(
        _$SummaryTypeEnumMap,
        json['defaultSummaryType'],
      ),
      freeSummariesUsedToday: (json['freeSummariesUsedToday'] as num?)?.toInt() ?? 0,
      lastFreeSummaryDate: (json['lastFreeSummaryDate'] as String?) ?? '',
    );

Map<String, dynamic> _$SummariesStateToJson(SummariesState instance) =>
    <String, dynamic>{
      'summaries': instance.summaries,
      'ratedSummaries': instance.ratedSummaries.toList(),
      'textCounter': instance.textCounter,
      'defaultSummaryType': _$SummaryTypeEnumMap[instance.defaultSummaryType]!,
      'freeSummariesUsedToday': instance.freeSummariesUsedToday,
      'lastFreeSummaryDate': instance.lastFreeSummaryDate,
    };

const _$SummaryTypeEnumMap = {
  SummaryType.long: 'long',
  SummaryType.short: 'short',
};
