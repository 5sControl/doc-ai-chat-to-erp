part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQuiz extends QuizEvent {
  final String documentKey;
  final String text;
  final int numQuestions;
  final String difficulty;

  const GenerateQuiz({
    required this.documentKey,
    required this.text,
    this.numQuestions = 5,
    this.difficulty = "medium",
  });

  @override
  List<Object?> get props => [documentKey, text, numQuestions, difficulty];
}

class SubmitAnswer extends QuizEvent {
  final String documentKey;
  final String questionId;
  final String selectedAnswerId;

  const SubmitAnswer({
    required this.documentKey,
    required this.questionId,
    required this.selectedAnswerId,
  });

  @override
  List<Object?> get props => [documentKey, questionId, selectedAnswerId];
}

class NextQuestion extends QuizEvent {
  final String documentKey;

  const NextQuestion({required this.documentKey});

  @override
  List<Object?> get props => [documentKey];
}

class ResetQuiz extends QuizEvent {
  final String documentKey;

  const ResetQuiz({required this.documentKey});

  @override
  List<Object?> get props => [documentKey];
}

class CompleteQuiz extends QuizEvent {
  final String documentKey;

  const CompleteQuiz({required this.documentKey});

  @override
  List<Object?> get props => [documentKey];
}

