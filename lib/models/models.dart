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
  final String? summary;
  final String? summaryError;

  const Summary({required this.summary, this.summaryError});

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

@JsonSerializable()
class SummaryData {
  SummaryStatus status;
  final DateTime date;
  final String? summary;
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? error;
  final bool opened;

  SummaryData(
      {required this.status,
      required this.date,
      required this.opened,
      this.summary,
      this.imageUrl,
      this.title,
      this.description,
      this.error});

  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryDataToJson(this);
}

enum SummaryStatus { Loading, Complete, Error, Rejected }

class UserModel {
  final String? id;
  final String? email;
  final String? displayName;
  UserModel({
    this.id,
    this.email,
    this.displayName,
  });
}
