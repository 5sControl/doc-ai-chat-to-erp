import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';

part 'models.g.dart';

// @JsonSerializable()
// class SharedMediaItem extends SharedMediaFile {
//   SharedMediaItem(
//       {required super.path,
//       required super.type,
//       super.duration,
//       super.message,
//       super.mimeType,
//       super.thumbnail});
//
//   factory SharedMediaItem.fromJson(Map<String, dynamic> json) =>
//       _$SharedMediaItemFromJson(json);
//
//   Map<String, dynamic> toJson() => _$SharedMediaItemToJson(this);
// }

@JsonSerializable()
class Summary extends Equatable {
  final String? summary;
  final String? summaryError;

  const Summary({required this.summary, this.summaryError});

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);

  @override
  List<Object?> get props => [summary, summaryError];
}

@JsonSerializable()
class SummaryData extends Equatable {
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

  @override
  List<Object?> get props =>
      [summary, status, date, imageUrl, title, error, opened, description];
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