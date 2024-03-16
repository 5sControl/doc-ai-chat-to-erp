// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedMediaItem _$SharedMediaItemFromJson(Map<String, dynamic> json) =>
    SharedMediaItem(
      path: json['path'] as String,
      type: $enumDecode(_$SharedMediaTypeEnumMap, json['type']),
      duration: json['duration'] as int?,
      message: json['message'] as String?,
      mimeType: json['mimeType'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$SharedMediaItemToJson(SharedMediaItem instance) =>
    <String, dynamic>{
      'path': instance.path,
      'thumbnail': instance.thumbnail,
      'duration': instance.duration,
      'type': _$SharedMediaTypeEnumMap[instance.type]!,
      'mimeType': instance.mimeType,
      'message': instance.message,
    };

const _$SharedMediaTypeEnumMap = {
  SharedMediaType.image: 'image',
  SharedMediaType.video: 'video',
  SharedMediaType.text: 'text',
  SharedMediaType.file: 'file',
  SharedMediaType.url: 'url',
};

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
      opened: json['opened'] as bool,
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
      'opened': instance.opened,
    };

const _$SummaryStatusEnumMap = {
  SummaryStatus.Loading: 'Loading',
  SummaryStatus.Complete: 'Complete',
  SummaryStatus.Error: 'Error',
  SummaryStatus.Rejected: 'Rejected',
};
