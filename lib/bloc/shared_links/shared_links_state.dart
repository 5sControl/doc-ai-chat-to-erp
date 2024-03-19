part of 'shared_links_bloc.dart';

@JsonSerializable()
class SharedLinksState extends Equatable {
  final Map<String, SummaryData> savedLinks;
  final int textCounter;
  final Set<String> newSummaries;

  const SharedLinksState({
    required this.savedLinks,
    required this.textCounter,
    required this.newSummaries,
  });

  SharedLinksState copyWith({
    Map<String, SummaryData>? savedLinks,
    int? textCounter,
    Set<String>? newSummaries,
  }) {
    return SharedLinksState(
        textCounter: textCounter ?? this.textCounter,
        savedLinks: savedLinks ?? this.savedLinks,
        newSummaries: newSummaries ?? this.newSummaries
    );
  }

  @override
  List<Object> get props => [savedLinks, newSummaries];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}