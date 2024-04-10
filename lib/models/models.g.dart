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
      formattedDate: json['formattedDate'] as String,
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
      'formattedDate': instance.formattedDate,
    };

const _$SummaryStatusEnumMap = {
  SummaryStatus.Loading: 'Loading',
  SummaryStatus.Complete: 'Complete',
  SummaryStatus.Error: 'Error',
  SummaryStatus.Rejected: 'Rejected',
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
