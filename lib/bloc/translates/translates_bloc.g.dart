// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translates_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslatesState _$TranslatesStateFromJson(Map<String, dynamic> json) =>
    TranslatesState(
      shortTranslates: (json['shortTranslates'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SummaryTranslate.fromJson(e as Map<String, dynamic>)),
      ),
      longTranslates: (json['longTranslates'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, SummaryTranslate.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$TranslatesStateToJson(TranslatesState instance) =>
    <String, dynamic>{
      'shortTranslates': instance.shortTranslates,
      'longTranslates': instance.longTranslates,
    };
