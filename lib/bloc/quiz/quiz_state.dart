part of 'quiz_bloc.dart';

class QuizState extends Equatable {
  final Map<String, Quiz> quizzes;

  const QuizState({required this.quizzes});

  QuizState copyWith({
    Map<String, Quiz>? quizzes,
  }) {
    return QuizState(
      quizzes: quizzes ?? this.quizzes,
    );
  }

  Quiz? getQuiz(String documentKey) {
    return quizzes[documentKey];
  }

  factory QuizState.fromJson(Map<String, dynamic> json) {
    final quizzesMap = <String, Quiz>{};
    if (json['quizzes'] != null) {
      final quizzesJson = json['quizzes'] as Map<String, dynamic>;
      quizzesJson.forEach((key, value) {
        try {
          quizzesMap[key] = Quiz.fromJson(value as Map<String, dynamic>);
        } catch (e) {
          // Skip invalid quiz entries
        }
      });
    }
    return QuizState(quizzes: quizzesMap);
  }

  Map<String, dynamic> toJson() {
    final quizzesMap = <String, dynamic>{};
    quizzes.forEach((key, quiz) {
      try {
        quizzesMap[key] = quiz.toJson();
      } catch (e) {
        // Skip invalid quiz entries
      }
    });
    return {'quizzes': quizzesMap};
  }

  @override
  List<Object> get props => [quizzes];
}

