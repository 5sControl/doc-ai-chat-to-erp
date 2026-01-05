import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/services/summaryApi.dart';
import '../../models/models.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends HydratedBloc<QuizEvent, QuizState> {
  final MixpanelBloc mixpanelBloc;
  
  QuizBloc({required this.mixpanelBloc})
      : super(const QuizState(quizzes: {})) {
    on<GenerateQuiz>((event, emit) async {
      // Check if quiz already exists
      if (state.quizzes.containsKey(event.documentKey)) {
        final existingQuiz = state.quizzes[event.documentKey]!;
        if (existingQuiz.status != QuizStatus.error) {
          // Quiz already exists, don't regenerate
          return;
        }
      }

      // Emit loading state
      final loadingQuiz = Quiz(
        quizId: 'loading_${DateTime.now().millisecondsSinceEpoch}',
        documentKey: event.documentKey,
        questions: [],
        status: QuizStatus.loading,
        currentQuestionIndex: 0,
      );

      final Map<String, Quiz> quizzes = Map.from(state.quizzes);
      quizzes[event.documentKey] = loadingQuiz;
      emit(state.copyWith(quizzes: quizzes));

      try {
        final quiz = await SummaryRepository().generateQuizFromText(
          text: event.text,
          documentKey: event.documentKey,
          numQuestions: event.numQuestions,
          difficulty: event.difficulty,
        );

        final Map<String, Quiz> updatedQuizzes = Map.from(state.quizzes);
        updatedQuizzes[event.documentKey] = quiz.copyWith(
          status: QuizStatus.ready,
          currentQuestionIndex: 0,
        );
        emit(state.copyWith(quizzes: updatedQuizzes));
      } catch (e) {
        mixpanelBloc.add(
          TrackResearchSummary(url: event.documentKey, error: e.toString()),
        );
        final Map<String, Quiz> errorQuizzes = Map.from(state.quizzes);
        final errorQuiz = Quiz(
          quizId: 'error_${DateTime.now().millisecondsSinceEpoch}',
          documentKey: event.documentKey,
          questions: [],
          status: QuizStatus.error,
          currentQuestionIndex: 0,
        );
        errorQuizzes[event.documentKey] = errorQuiz;
        emit(state.copyWith(quizzes: errorQuizzes));
      }
    }, transformer: droppable());

    on<SubmitAnswer>((event, emit) {
      final quiz = state.quizzes[event.documentKey];
      if (quiz == null || quiz.status != QuizStatus.inProgress) {
        return;
      }

      final currentIndex = quiz.currentQuestionIndex ?? 0;
      if (currentIndex >= quiz.questions.length) {
        return;
      }

      final currentQuestion = quiz.questions[currentIndex];
      final isCorrect = currentQuestion.correctAnswerId == event.selectedAnswerId;

      // Update question with user answer
      final updatedQuestions = List<QuizQuestion>.from(quiz.questions);
      updatedQuestions[currentIndex] = currentQuestion.copyWith(
        userAnswerId: event.selectedAnswerId,
        isCorrect: isCorrect,
      );

      // Create answer record
      final answer = QuizAnswer(
        questionId: event.questionId,
        selectedAnswerId: event.selectedAnswerId,
        isCorrect: isCorrect,
        answeredAt: DateTime.now(),
      );

      final existingAnswers = List<QuizAnswer>.from(quiz.answers ?? []);
      // Remove existing answer for this question if any
      existingAnswers.removeWhere((a) => a.questionId == event.questionId);
      existingAnswers.add(answer);

      final updatedQuiz = quiz.copyWith(
        questions: updatedQuestions,
        answers: existingAnswers,
      );

      final Map<String, Quiz> quizzes = Map.from(state.quizzes);
      quizzes[event.documentKey] = updatedQuiz;
      emit(state.copyWith(quizzes: quizzes));
    });

    on<NextQuestion>((event, emit) {
      final quiz = state.quizzes[event.documentKey];
      if (quiz == null || quiz.status != QuizStatus.inProgress) {
        return;
      }

      final currentIndex = (quiz.currentQuestionIndex ?? 0) + 1;
      
      if (currentIndex >= quiz.questions.length) {
        // Quiz completed
        add(CompleteQuiz(documentKey: event.documentKey));
        return;
      }

      final updatedQuiz = quiz.copyWith(
        currentQuestionIndex: currentIndex,
        status: QuizStatus.inProgress,
      );

      final Map<String, Quiz> quizzes = Map.from(state.quizzes);
      quizzes[event.documentKey] = updatedQuiz;
      emit(state.copyWith(quizzes: quizzes));
    });

    on<CompleteQuiz>((event, emit) {
      final quiz = state.quizzes[event.documentKey];
      if (quiz == null) {
        return;
      }

      final completedQuiz = quiz.copyWith(
        status: QuizStatus.completed,
        completedAt: DateTime.now(),
      );

      final Map<String, Quiz> quizzes = Map.from(state.quizzes);
      quizzes[event.documentKey] = completedQuiz;
      emit(state.copyWith(quizzes: quizzes));
    });

    on<ResetQuiz>((event, emit) {
      final quiz = state.quizzes[event.documentKey];
      if (quiz == null) {
        return;
      }

      // Reset quiz to ready state
      final resetQuestions = quiz.questions.map((q) {
        return q.copyWith(
          userAnswerId: null,
          isCorrect: null,
        );
      }).toList();

      final resetQuiz = quiz.copyWith(
        questions: resetQuestions,
        status: QuizStatus.ready,
        currentQuestionIndex: 0,
        answers: [],
        completedAt: null,
      );

      final Map<String, Quiz> quizzes = Map.from(state.quizzes);
      quizzes[event.documentKey] = resetQuiz;
      emit(state.copyWith(quizzes: quizzes));
    });
  }

  void startQuiz(String documentKey) {
    final quiz = state.quizzes[documentKey];
    if (quiz == null || quiz.status != QuizStatus.ready) {
      return;
    }

    final startedQuiz = quiz.copyWith(
      status: QuizStatus.inProgress,
      currentQuestionIndex: 0,
    );

    final Map<String, Quiz> quizzes = Map.from(state.quizzes);
    quizzes[documentKey] = startedQuiz;
    emit(state.copyWith(quizzes: quizzes));
  }

  @override
  QuizState? fromJson(Map<String, dynamic> json) {
    try {
      return QuizState.fromJson(json);
    } catch (e) {
      return const QuizState(quizzes: {});
    }
  }

  @override
  Map<String, dynamic>? toJson(QuizState state) {
    try {
      return state.toJson();
    } catch (e) {
      return {'quizzes': {}};
    }
  }
}

