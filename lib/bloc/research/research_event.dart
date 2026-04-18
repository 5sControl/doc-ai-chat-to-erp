part of 'research_bloc.dart';

abstract class ResearchEvent extends Equatable {
  const ResearchEvent();
}

class MakeQuestionFromUrl extends ResearchEvent {
  final String summaryKey;
  final String question;
  final String? systemHint;
  /// Server document UUID (v2). When set, question is sent via v2 chat API.
  final String? serverId;
  const MakeQuestionFromUrl({
    required this.question,
    required this.summaryKey,
    this.systemHint,
    this.serverId,
  });

  @override
  List<Object?> get props => [summaryKey, question, systemHint, serverId];
}

class MakeQuestionFromFile extends ResearchEvent {
  final String summaryKey;
  final String filePath;
  final String question;
  final String? systemHint;
  final String? serverId;
  const MakeQuestionFromFile({
    required this.filePath,
    required this.summaryKey,
    required this.question,
    this.systemHint,
    this.serverId,
  });

  @override
  List<Object?> get props => [summaryKey, filePath, question, systemHint, serverId];
}

class MakeQuestionFromText extends ResearchEvent {
  final String summaryKey;
  final String text;
  final String question;
  final String? systemHint;
  final String? serverId;
  const MakeQuestionFromText({
    required this.text,
    required this.summaryKey,
    required this.question,
    this.systemHint,
    this.serverId,
  });

  @override
  List<Object?> get props => [summaryKey, text, question, systemHint, serverId];
}

class InitializeDemoResearch extends ResearchEvent {
  const InitializeDemoResearch();

  @override
  List<Object?> get props => [];
}
