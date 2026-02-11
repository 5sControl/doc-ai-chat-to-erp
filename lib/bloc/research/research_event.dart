part of 'research_bloc.dart';

abstract class ResearchEvent extends Equatable {
  const ResearchEvent();
}

class MakeQuestionFromUrl extends ResearchEvent {
  final String summaryKey;
  final String question;
  final String? systemHint;
  const MakeQuestionFromUrl({
    required this.question,
    required this.summaryKey,
    this.systemHint,
  });

  @override
  List<Object?> get props => [summaryKey, question, systemHint];
}

class MakeQuestionFromFile extends ResearchEvent {
  final String summaryKey;
  final String filePath;
  final String question;
  final String? systemHint;
  const MakeQuestionFromFile({
    required this.filePath,
    required this.summaryKey,
    required this.question,
    this.systemHint,
  });

  @override
  List<Object?> get props => [summaryKey, filePath, question, systemHint];
}

class MakeQuestionFromText extends ResearchEvent {
  final String summaryKey;
  final String text;
  final String question;
  final String? systemHint;
  const MakeQuestionFromText({
    required this.text,
    required this.summaryKey,
    required this.question,
    this.systemHint,
  });

  @override
  List<Object?> get props => [summaryKey, text, question, systemHint];
}

class InitializeDemoResearch extends ResearchEvent {
  const InitializeDemoResearch();

  @override
  List<Object?> get props => [];
}
