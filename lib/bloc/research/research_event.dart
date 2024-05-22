part of 'research_bloc.dart';

abstract class ResearchEvent extends Equatable {
  const ResearchEvent();
}

class MakeQuestion extends ResearchEvent {
  final String summaryKey;
  final String question;
  const MakeQuestion({required this.question, required this.summaryKey});

  @override
  List<Object?> get props => [summaryKey, question];
}

class LikeAnswer extends ResearchEvent {
  final String summaryKey;
  final String answer;

  const LikeAnswer({required this.summaryKey, required this.answer});

  @override
  List<Object?> get props => [summaryKey, answer];
}

class DislikeAnswer extends ResearchEvent {
  final String summaryKey;
  final String answer;

  const DislikeAnswer({required this.summaryKey, required this.answer});

  @override
  List<Object?> get props => [summaryKey, answer];
}
