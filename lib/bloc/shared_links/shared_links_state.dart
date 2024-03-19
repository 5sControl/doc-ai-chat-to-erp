part of 'shared_links_bloc.dart';

@JsonSerializable()
class SharedLinksState extends Equatable {
  final Map<String, SummaryData> savedLinks;
  final int textCounter;
  final Set<String> openedSummaries;

  const SharedLinksState({
    required this.savedLinks,
    required this.textCounter,
    required this.openedSummaries
  });

  SharedLinksState copyWith({
    Map<String, SummaryData>? savedLinks,
    int? textCounter,
    Set<String>? loadedSummaries,
  }) {
    return SharedLinksState(
        textCounter: textCounter ?? this.textCounter,
        savedLinks: savedLinks ?? this.savedLinks,
        openedSummaries: openedSummaries ?? this.openedSummaries
    );
  }

  @override
  List<Object> get props => [savedLinks, openedSummaries];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
