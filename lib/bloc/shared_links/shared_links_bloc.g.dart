// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_links_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLinksState _$SharedLinksStateFromJson(Map<String, dynamic> json) =>
    SharedLinksState(
      savedLinks: (json['savedLinks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, SummaryData.fromJson(e as Map<String, dynamic>)),
      ),
      textCounter: json['textCounter'] as int,
      newSummaries: (json['newSummaries'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$SharedLinksStateToJson(SharedLinksState instance) =>
    <String, dynamic>{
      'savedLinks': instance.savedLinks,
      'textCounter': instance.textCounter,
      'newSummaries': instance.newSummaries.toList(),
    };
