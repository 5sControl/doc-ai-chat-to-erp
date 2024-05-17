import 'package:equatable/equatable.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

enum SummaryOrigin { file, url, text }

enum SummaryStatus { loading, complete, error, rejected, stopped, initial }

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

  const Summary({this.summaryText,  this.summaryError});

  Summary copyWith({
    String? summaryText,
    String? summaryError,
  }) {
    return Summary(
      summaryText: summaryText ?? this.summaryText,
      summaryError: summaryError ?? this.summaryError,
    );
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
        summaryOrigin
      ];
}

// @JsonSerializable()
// class StoreProduct extends ProductDetails with EquatableMixin {
//   StoreProduct(
//       {required super.id,
//       required super.currencySymbol,
//       required super.title,
//       required super.description,
//       required super.price,
//       required super.rawPrice,
//       required super.currencyCode});
//
//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         description,
//         price,
//         title,
//         rawPrice,
//         currencyCode,
//         currencySymbol
//       ];
//
//   factory StoreProduct.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StoreProductToJson(this);
// }

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
