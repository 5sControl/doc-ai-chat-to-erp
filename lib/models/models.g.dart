// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      summary: json['summary'] as String?,
      summaryError: json['summaryError'] as String?,
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'summary': instance.summary,
      'summaryError': instance.summaryError,
    };

SummaryData _$SummaryDataFromJson(Map<String, dynamic> json) => SummaryData(
      status: $enumDecode(_$SummaryStatusEnumMap, json['status']),
      date: DateTime.parse(json['date'] as String),
      summary: json['summary'] as String?,
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SummaryDataToJson(SummaryData instance) =>
    <String, dynamic>{
      'status': _$SummaryStatusEnumMap[instance.status]!,
      'date': instance.date.toIso8601String(),
      'summary': instance.summary,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'error': instance.error,
    };

const _$SummaryStatusEnumMap = {
  SummaryStatus.Loading: 'Loading',
  SummaryStatus.Complete: 'Complete',
  SummaryStatus.Error: 'Error',
  SummaryStatus.Rejected: 'Rejected',
};
