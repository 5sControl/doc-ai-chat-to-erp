part of 'summaries_bloc.dart';

@JsonSerializable()
class SummariesState extends Equatable {
  final Map<String, SummaryData> summaries;
  final Set<String> ratedSummaries;
  // final int dailyLimit;
  // final Map<String, int> dailySummariesMap;
  final int textCounter;
  final SummaryType defaultSummaryType;
  final int freeSummariesUsedToday;
  final String lastFreeSummaryDate;

  const SummariesState({
    required this.summaries,
    required this.ratedSummaries,
    required this.textCounter,
    required this.defaultSummaryType,
    required this.freeSummariesUsedToday,
    required this.lastFreeSummaryDate,
  });

  SummariesState copyWith({
    Map<String, SummaryData>? summaries,
    Set<String>? ratedSummaries,
    int? textCounter,
    SummaryType? defaultSummaryType,
    int? freeSummariesUsedToday,
    String? lastFreeSummaryDate,
  }) {
    return SummariesState(
      summaries: summaries ?? this.summaries,
      ratedSummaries: ratedSummaries ?? this.ratedSummaries,
      textCounter: textCounter ?? this.textCounter,
      defaultSummaryType: defaultSummaryType ?? this.defaultSummaryType,
      freeSummariesUsedToday:
          freeSummariesUsedToday ?? this.freeSummariesUsedToday,
      lastFreeSummaryDate: lastFreeSummaryDate ?? this.lastFreeSummaryDate,
    );
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
        freeSummariesUsedToday,
        lastFreeSummaryDate,
      ];
}
