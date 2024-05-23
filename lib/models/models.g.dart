// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryPreview _$SummaryPreviewFromJson(Map<String, dynamic> json) =>
    SummaryPreview(
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$SummaryPreviewToJson(SummaryPreview instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'title': instance.title,
    };

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      contextLength: json['contextLength'] as int?,
      summaryText: json['summaryText'] as String?,
      summaryError: json['summaryError'] as String?,
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'summaryText': instance.summaryText,
      'summaryError': instance.summaryError,
      'contextLength': instance.contextLength,
    };

SummaryData _$SummaryDataFromJson(Map<String, dynamic> json) => SummaryData(
      shortSummaryStatus:
          $enumDecode(_$SummaryStatusEnumMap, json['shortSummaryStatus']),
      longSummaryStatus:
          $enumDecode(_$SummaryStatusEnumMap, json['longSummaryStatus']),
      date: DateTime.parse(json['date'] as String),
      summaryOrigin: $enumDecode(_$SummaryOriginEnumMap, json['summaryOrigin']),
      shortSummary:
          Summary.fromJson(json['shortSummary'] as Map<String, dynamic>),
      longSummary:
          Summary.fromJson(json['longSummary'] as Map<String, dynamic>),
      summaryPreview: SummaryPreview.fromJson(
          json['summaryPreview'] as Map<String, dynamic>),
      filePath: json['filePath'] as String?,
      userText: json['userText'] as String?,
    );

Map<String, dynamic> _$SummaryDataToJson(SummaryData instance) =>
    <String, dynamic>{
      'shortSummaryStatus':
          _$SummaryStatusEnumMap[instance.shortSummaryStatus]!,
      'longSummaryStatus': _$SummaryStatusEnumMap[instance.longSummaryStatus]!,
      'date': instance.date.toIso8601String(),
      'summaryOrigin': _$SummaryOriginEnumMap[instance.summaryOrigin]!,
      'summaryPreview': instance.summaryPreview,
      'shortSummary': instance.shortSummary,
      'longSummary': instance.longSummary,
      'filePath': instance.filePath,
      'userText': instance.userText,
    };

const _$SummaryStatusEnumMap = {
  SummaryStatus.loading: 'loading',
  SummaryStatus.complete: 'complete',
  SummaryStatus.error: 'error',
  SummaryStatus.rejected: 'rejected',
  SummaryStatus.stopped: 'stopped',
  SummaryStatus.initial: 'initial',
};

const _$SummaryOriginEnumMap = {
  SummaryOrigin.file: 'file',
  SummaryOrigin.url: 'url',
  SummaryOrigin.text: 'text',
};

SummaryTranslate _$SummaryTranslateFromJson(Map<String, dynamic> json) =>
    SummaryTranslate(
      translate: json['translate'] as String?,
      translateStatus:
          $enumDecode(_$TranslateStatusEnumMap, json['translateStatus']),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SummaryTranslateToJson(SummaryTranslate instance) =>
    <String, dynamic>{
      'translate': instance.translate,
      'translateStatus': _$TranslateStatusEnumMap[instance.translateStatus]!,
      'isActive': instance.isActive,
    };

const _$TranslateStatusEnumMap = {
  TranslateStatus.loading: 'loading',
  TranslateStatus.complete: 'complete',
  TranslateStatus.error: 'error',
  TranslateStatus.initial: 'initial',
};

ResearchQuestion _$ResearchQuestionFromJson(Map<String, dynamic> json) =>
    ResearchQuestion(
      question: json['question'] as String,
      answer: json['answer'] as String?,
      answerStatus: $enumDecode(_$AnswerStatusEnumMap, json['answerStatus']),
      like: $enumDecode(_$LikeEnumMap, json['like']),
    );

Map<String, dynamic> _$ResearchQuestionToJson(ResearchQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'answerStatus': _$AnswerStatusEnumMap[instance.answerStatus]!,
      'like': _$LikeEnumMap[instance.like]!,
    };

const _$AnswerStatusEnumMap = {
  AnswerStatus.loading: 'loading',
  AnswerStatus.completed: 'completed',
  AnswerStatus.error: 'error',
};

const _$LikeEnumMap = {
  Like.unliked: 'unliked',
  Like.liked: 'liked',
  Like.disliked: 'disliked',
};
