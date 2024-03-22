part of 'shared_links_bloc.dart';

@JsonSerializable()
class SharedLinksState extends Equatable {
  final Map<String, SummaryData> savedLinks;
  final int textCounter;
  final Set<String> newSummaries;
  final Set<String> ratedSummaries;
  final int dailyLimit;
  final Map<String, int> dailySummariesMap;

  const SharedLinksState({
    required this.savedLinks,
    required this.textCounter,
    required this.newSummaries,
    required this.ratedSummaries,
    required this.dailyLimit,
    required this.dailySummariesMap,
  });

  SharedLinksState copyWith({
    Map<String, SummaryData>? savedLinks,
    int? textCounter,
    Set<String>? newSummaries,
    Set<String>? ratedSummaries,
    int? dailyLimit,
    Map<String, int>? dailySummariesMap,
  }) {
    return SharedLinksState(
      textCounter: textCounter ?? this.textCounter,
      savedLinks: savedLinks ?? this.savedLinks,
      newSummaries: newSummaries ?? this.newSummaries,
      ratedSummaries: ratedSummaries ?? this.ratedSummaries,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      dailySummariesMap: dailySummariesMap ?? this.dailySummariesMap,
    );
  }

  @override
  List<Object> get props =>
      [savedLinks, newSummaries, ratedSummaries, dailyLimit, textCounter, dailySummariesMap];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
