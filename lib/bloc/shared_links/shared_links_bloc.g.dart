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
      ratedSummaries: (json['ratedSummaries'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      dailyLimit: json['dailyLimit'] as int,
      dailySummariesMap:
          Map<String, int>.from(json['dailySummariesMap'] as Map),
    );

Map<String, dynamic> _$SharedLinksStateToJson(SharedLinksState instance) =>
    <String, dynamic>{
      'savedLinks': instance.savedLinks,
      'textCounter': instance.textCounter,
      'newSummaries': instance.newSummaries.toList(),
      'ratedSummaries': instance.ratedSummaries.toList(),
      'dailyLimit': instance.dailyLimit,
      'dailySummariesMap': instance.dailySummariesMap,
    };
