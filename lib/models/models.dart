import 'package:equatable/equatable.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

enum SummaryOrigin { file, url, text }

enum SummaryStatus { loading, complete, error, rejected, stopped, initial }

enum TranslateStatus { loading, complete, error, initial }
// enum SummaryType { short, long }

@JsonSerializable()
class SummaryPreview extends Equatable {
  final String? imageUrl;
  final String? title;
  const SummaryPreview({this.title, this.imageUrl});

  SummaryPreview copyWith({
    String? imageUrl,
    String? title,
  }) {
    return SummaryPreview(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }

  factory SummaryPreview.fromJson(Map<String, dynamic> json) =>
      _$SummaryPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryPreviewToJson(this);

  @override
  List<Object?> get props => [title, imageUrl];
}

@JsonSerializable()
class Summary extends Equatable {
  final String? summaryText;
  final String? summaryError;

  const Summary({this.summaryText, this.summaryError});

  Summary copyWith({
    String? summaryText,
    String? summaryError,
    SummaryTranslate? summaryTranslate,
  }) {
    return Summary(
        summaryText: summaryText ?? this.summaryText,
        summaryError: summaryError ?? this.summaryError);
  }

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);

  @override
  List<Object?> get props => [summaryText, summaryError];
}

@JsonSerializable()
class SummaryData extends Equatable {
  final SummaryStatus shortSummaryStatus;
  final SummaryStatus longSummaryStatus;
  final DateTime date;
  final SummaryOrigin summaryOrigin;
  final SummaryPreview summaryPreview;
  final Summary shortSummary;
  final Summary longSummary;

  const SummaryData({
    required this.shortSummaryStatus,
    required this.longSummaryStatus,
    required this.date,
    required this.summaryOrigin,
    required this.shortSummary,
    required this.longSummary,
    required this.summaryPreview,
  });

  SummaryData copyWith({
    SummaryStatus? shortSummaryStatus,
    SummaryStatus? longSummaryStatus,
    SummaryOrigin? summaryOrigin,
    DateTime? date,
    Summary? shortSummary,
    Summary? longSummary,
    SummaryPreview? summaryPreview,
  }) {
    return SummaryData(
      shortSummaryStatus: shortSummaryStatus ?? this.shortSummaryStatus,
      longSummaryStatus: longSummaryStatus ?? this.longSummaryStatus,
      summaryOrigin: summaryOrigin ?? this.summaryOrigin,
      date: date ?? this.date,
      shortSummary: shortSummary ?? this.shortSummary,
      longSummary: longSummary ?? this.longSummary,
      summaryPreview: summaryPreview ?? this.summaryPreview,
    );
  }

  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryDataToJson(this);

  @override
  List<Object?> get props => [
        shortSummary,
        longSummary,
        shortSummaryStatus,
        longSummaryStatus,
        date,
        summaryPreview,
        summaryOrigin,
      ];
}

@JsonSerializable()
class SummaryTranslate extends Equatable {
  final String? translate;
  final TranslateStatus translateStatus;
  final bool isActive;
  const SummaryTranslate(
      {required this.translate,
      required this.translateStatus,
      required this.isActive});

  SummaryTranslate copyWith({
    String? translate,
    TranslateStatus? translateStatus,
    bool? isActive,
  }) {
    return SummaryTranslate(
        translate: translate ?? this.translate,
        translateStatus: translateStatus ?? this.translateStatus,
        isActive: isActive ?? this.isActive);
  }

  factory SummaryTranslate.fromJson(Map<String, dynamic> json) =>
      _$SummaryTranslateFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryTranslateToJson(this);

  @override
  List<Object?> get props => [translate, translateStatus, isActive];
}

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
