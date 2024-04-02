part of 'summaries_bloc.dart';

@JsonSerializable()
class SummariesState extends Equatable {
  final Map<String, SummaryData> summaries;

  const SummariesState({required this.summaries});

  SummariesState copyWith({
    Map<String, SummaryData>? summaries,
  }) {
    return SummariesState(summaries: summaries ?? this.summaries);
  }

  factory SummariesState.fromJson(Map<String, dynamic> json) =>
      _$SummariesStateFromJson(json);

  Map<String, dynamic> toJson() => _$SummariesStateToJson(this);

  @override
  List<Object> get props => [summaries];
}
