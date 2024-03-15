part of 'shared_links_bloc.dart';

@JsonSerializable()
class SharedLinksState extends Equatable {
  final Map<String, SummaryData> savedLinks;
  final int textCounter;
  final Set<String> loadQueue;

  const SharedLinksState(
      {required this.savedLinks,
      required this.textCounter,
      required this.loadQueue});

  SharedLinksState copyWith({
    Map<String, SummaryData>? savedLinks,
    int? textCounter,
    Set<String>? loadQueue,
  }) {
    return SharedLinksState(
        loadQueue: loadQueue ?? this.loadQueue,
        textCounter: textCounter ?? this.textCounter,
        savedLinks: savedLinks ?? this.savedLinks);
  }

  @override
  List<Object> get props => [savedLinks, loadQueue];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
