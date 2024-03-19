part of 'shared_links_bloc.dart';

@JsonSerializable()
class SharedLinksState extends Equatable {
  final Map<String, SummaryData> savedLinks;
  final int textCounter;

  const SharedLinksState({
    required this.savedLinks,
    required this.textCounter,
  });

  SharedLinksState copyWith({
    Map<String, SummaryData>? savedLinks,
    int? textCounter,
    Set<String>? loadQueue,
  }) {
    return SharedLinksState(
        textCounter: textCounter ?? this.textCounter,
        savedLinks: savedLinks ?? this.savedLinks);
  }

  @override
  List<Object> get props => [savedLinks];

  factory SharedLinksState.fromJson(Map<String, dynamic> json) =>
      _$SharedLinksStateFromJson(json);

  Map<String, dynamic> toJson() => _$SharedLinksStateToJson(this);
}
