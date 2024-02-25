part of 'shared_links_bloc.dart';



@JsonSerializable()
class SharedLinksState extends Equatable {
  // final List<SharedMediaItem> savedSharedLinks;
  final Map<String, SummaryData> savedLinks;

  const SharedLinksState({required this.savedLinks});

  SharedLinksState copyWith({
    // List<SharedMediaItem>? savedSharedLinks,
    Map<String, SummaryData>? savedLinks,
    // String? loadingLink,
  }) {
    return SharedLinksState(
        // savedSharedLinks: savedSharedLinks ?? this.savedSharedLinks,
        savedLinks: savedLinks ?? this.savedLinks);
  }

  @override
  List<Object> get props => [savedLinks];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
