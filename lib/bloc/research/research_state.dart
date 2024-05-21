part of 'research_bloc.dart';

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

  @override
  List<Object> get props => [questions, questions.values];
}
