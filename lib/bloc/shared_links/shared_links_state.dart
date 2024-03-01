part of 'shared_links_bloc.dart';



@JsonSerializable()
class SharedLinksState extends Equatable {
  // final List<SharedMediaItem> savedSharedLinks;
  final Map<String, SummaryData> savedLinks;
  final int textCounter;

  const SharedLinksState({required this.savedLinks, required this.textCounter});

  SharedLinksState copyWith({
    // List<SharedMediaItem>? savedSharedLinks,
    Map<String, SummaryData>? savedLinks,
    int? textCounter
    // String? loadingLink,
  }) {
    return SharedLinksState(
        // savedSharedLinks: savedSharedLinks ?? this.savedSharedLinks,
        textCounter: textCounter ?? this.textCounter,
        savedLinks: savedLinks ?? this.savedLinks);
  }

  @override
  List<Object> get props => [savedLinks];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
