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
      summaryText: json['summaryText'] as String?,
      summaryError: json['summaryError'] as String?,
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'summaryText': instance.summaryText,
      'summaryError': instance.summaryError,
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

StoreProduct _$StoreProductFromJson(Map<String, dynamic> json) => StoreProduct(
      id: json['id'] as String,
      currencySymbol: json['currencySymbol'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      rawPrice: (json['rawPrice'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
    );

Map<String, dynamic> _$StoreProductToJson(StoreProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'rawPrice': instance.rawPrice,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
    };
