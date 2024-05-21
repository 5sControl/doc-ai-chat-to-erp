part of 'summaries_bloc.dart';

@JsonSerializable()
class SummariesState extends Equatable {
  final Map<String, SummaryData> summaries;
  final Set<String> ratedSummaries;
  final int dailyLimit;
  final Map<String, int> dailySummariesMap;
  final int textCounter;
  final SummaryType defaultSummaryType;

  const SummariesState(
      {required this.summaries,
      required this.ratedSummaries,
      required this.dailyLimit,
      required this.dailySummariesMap,
      required this.textCounter,
      required this.defaultSummaryType});

  SummariesState copyWith(
      {Map<String, SummaryData>? summaries,
      Set<String>? ratedSummaries,
      int? dailyLimit,
      Map<String, int>? dailySummariesMap,
      int? textCounter,
      SummaryType? defaultSummaryType}) {
    return SummariesState(
        summaries: summaries ?? this.summaries,
        ratedSummaries: ratedSummaries ?? this.ratedSummaries,
        dailyLimit: dailyLimit ?? this.dailyLimit,
        dailySummariesMap: dailySummariesMap ?? this.dailySummariesMap,
        textCounter: textCounter ?? this.textCounter,
        defaultSummaryType: defaultSummaryType ?? this.defaultSummaryType);
  }

  factory SummariesState.fromJson(Map<String, dynamic> json) =>
      _$SummariesStateFromJson(json);

  Map<String, dynamic> toJson() => _$SummariesStateToJson(this);

  @override
  List<Object> get props => [
        summaries,
        ratedSummaries,
        dailyLimit,
        dailySummariesMap,
        textCounter,
        defaultSummaryType
      ];
}
