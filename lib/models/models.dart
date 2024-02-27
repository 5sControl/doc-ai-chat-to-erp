import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class SharedMediaItem extends SharedMediaFile {
  SharedMediaItem(
      {required super.path,
      required super.type,
      super.duration,
      super.message,
      super.mimeType,
      super.thumbnail});

  factory SharedMediaItem.fromJson(Map<String, dynamic> json) =>
      _$SharedMediaItemFromJson(json);

  Map<String, dynamic> toJson() => _$SharedMediaItemToJson(this);
}

@JsonSerializable()
class Summary {
  final String summary;
  final List<String> keyPoints;
  final String inDepthAnalysis;
  final String additionalContext;
  final List<String> supportingEvidence;
  final String implicationsConclusions;

  const Summary({
    required this.summary,
    required this.keyPoints,
    required this.inDepthAnalysis,
    required this.additionalContext,
    required this.supportingEvidence,
    required this.implicationsConclusions,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

@JsonSerializable()
class SummaryData {
  final SummaryStatus status;
  final DateTime date;
  final Summary? summary;

  SummaryData({ required this.status, required this.date, this.summary, });

  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryDataToJson(this);
}

enum SummaryStatus { Loading, Complete, Error }

class UserModel {
  final String? id;
  final String? email;
  final String? displayName;
  UserModel({ this.id, this.email, this.displayName, });
}