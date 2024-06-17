part of 'summaries_bloc.dart';

@JsonSerializable()
class SummariesState extends Equatable {
  final Map<String, SummaryData> summaries;
  final Set<String> ratedSummaries;
  // final int dailyLimit;
  // final Map<String, int> dailySummariesMap;
  final int textCounter;
  final SummaryType defaultSummaryType;
  final int freeSummaries;

  const SummariesState(
      {required this.summaries,
      required this.ratedSummaries,
      required this.textCounter,
      required this.defaultSummaryType,
      required this.freeSummaries});

  SummariesState copyWith(
      {Map<String, SummaryData>? summaries,
      Set<String>? ratedSummaries,
      int? textCounter,
      SummaryType? defaultSummaryType,
      int? freeSummaries}) {
    return SummariesState(
        summaries: summaries ?? this.summaries,
        ratedSummaries: ratedSummaries ?? this.ratedSummaries,
        // dailyLimit: dailyLimit ?? this.dailyLimit,
        // dailySummariesMap: dailySummariesMap ?? this.dailySummariesMap,
        textCounter: textCounter ?? this.textCounter,
        defaultSummaryType: defaultSummaryType ?? this.defaultSummaryType,
        freeSummaries: freeSummaries ?? this.freeSummaries);
  }

  factory SummariesState.fromJson(Map<String, dynamic> json) =>
      _$SummariesStateFromJson(json);

  Map<String, dynamic> toJson() => _$SummariesStateToJson(this);

  @override
  List<Object?> get props => [
        summaries,
        ratedSummaries,
        textCounter,
        defaultSummaryType,
        freeSummaries
      ];
}
