part of 'research_bloc.dart';

abstract class ResearchEvent extends Equatable {
  const ResearchEvent();
}

class MakeQuestionFromUrl extends ResearchEvent {
  final String summaryKey;
  final String question;
  const MakeQuestionFromUrl({required this.question, required this.summaryKey});

  @override
  List<Object?> get props => [summaryKey, question];
}

class MakeQuestionFromFile extends ResearchEvent {
  final String summaryKey;
  final String filePath;
  final String question;
  const MakeQuestionFromFile(
      {required this.filePath,
      required this.summaryKey,
      required this.question});

  @override
  List<Object?> get props => [summaryKey, filePath];
}

class MakeQuestionFromText extends ResearchEvent {
  final String summaryKey;
  final String text;
  final String question;
  const MakeQuestionFromText(
      {required this.text, required this.summaryKey, required this.question});

  @override
  List<Object> get props => [summaryKey, text, question];
}
