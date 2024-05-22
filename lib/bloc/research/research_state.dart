part of 'research_bloc.dart';

@JsonSerializable()
class ResearchState extends Equatable {
  final Map<String, List<ResearchQuestion>> questions;

  const ResearchState({required this.questions});

  ResearchState copyWith({
    Map<String, List<ResearchQuestion>>? questions,
  }) {
    return ResearchState(
      questions: questions ?? this.questions,
    );
  }

  factory ResearchState.fromJson(Map<String, dynamic> json) =>
      _$ResearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$ResearchStateToJson(this);

  @override
  List<Object> get props => [questions];
}
