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
      summary: json['summary'] as String,
      keyPoints:
          (json['keyPoints'] as List<dynamic>).map((e) => e as String).toList(),
      inDepthAnalysis: json['inDepthAnalysis'] as String,
      additionalContext: json['additionalContext'] as String,
      supportingEvidence: (json['supportingEvidence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      implicationsConclusions: json['implicationsConclusions'] as String,
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'summary': instance.summary,
      'keyPoints': instance.keyPoints,
      'inDepthAnalysis': instance.inDepthAnalysis,
      'additionalContext': instance.additionalContext,
      'supportingEvidence': instance.supportingEvidence,
      'implicationsConclusions': instance.implicationsConclusions,
    };

SummaryData _$SummaryDataFromJson(Map<String, dynamic> json) => SummaryData(
      status: $enumDecode(_$SummaryStatusEnumMap, json['status']),
      summary: json['summary'] == null
          ? null
          : Summary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SummaryDataToJson(SummaryData instance) =>
    <String, dynamic>{
      'status': _$SummaryStatusEnumMap[instance.status]!,
      'summary': instance.summary,
    };

const _$SummaryStatusEnumMap = {
  SummaryStatus.Loading: 'Loading',
  SummaryStatus.Complete: 'Complete',
  SummaryStatus.Error: 'Error',
};
