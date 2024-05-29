import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../models/models.dart';

part 'research_event.dart';
part 'research_bloc.g.dart';
part 'research_state.dart';

class ResearchBloc extends HydratedBloc<ResearchEvent, ResearchState> {
  ResearchBloc()
      : super(const ResearchState(questions: {
          'https://elang.app/en': [
            ResearchQuestion(
                question: 'How can I maximize efficiency with Summify?',
                answer:
                    "Setting up the share button in Summify's settings will allow you to easily distribute summaries to your preferred contacts or platforms as well it will simplify the process of sharing  summarizations with others.",
                answerStatus: AnswerStatus.completed,
                like: Like.liked)
          ]
        })) {
    on<MakeQuestionFromUrl>((event, emit) async {
      final newQuestion = ResearchQuestion(
          question: event.question,
          answerStatus: AnswerStatus.loading,
          answer: null,
          like: Like.unliked);

      final Map<String, List<ResearchQuestion>> questions =
          Map.from(state.questions);

      if (state.questions.containsKey(event.summaryKey)) {
        questions.update(event.summaryKey, (value) => [...value, newQuestion]);
      } else {
        questions.addAll({
          event.summaryKey: [newQuestion]
        });
      }

      emit(state.copyWith(questions: questions));

      try {
        final answer = await SummaryRepository().makeRequest(
            summaryUrl: event.summaryKey, question: event.question);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        print(e);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: null, answerStatus: AnswerStatus.error);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      }
    }, transformer: droppable());

    on<MakeQuestionFromFile>((event, emit) async {
      final newQuestion = ResearchQuestion(
          question: event.question,
          answerStatus: AnswerStatus.loading,
          answer: null,
          like: Like.unliked);

      final Map<String, List<ResearchQuestion>> questions =
          Map.from(state.questions);

      if (state.questions.containsKey(event.summaryKey)) {
        questions.update(event.summaryKey, (value) => [...value, newQuestion]);
      } else {
        questions.addAll({
          event.summaryKey: [newQuestion]
        });
      }

      emit(state.copyWith(questions: questions));

      try {
        final answer = await SummaryRepository().makeRequestFromFile(
            filePath: event.filePath, question: event.question);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        print(e);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: null, answerStatus: AnswerStatus.error);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      }
    }, transformer: droppable());

    on<MakeQuestionFromText>((event, emit) async {
      final newQuestion = ResearchQuestion(
          question: event.question,
          answerStatus: AnswerStatus.loading,
          answer: null,
          like: Like.unliked);

      final Map<String, List<ResearchQuestion>> questions =
          Map.from(state.questions);

      if (state.questions.containsKey(event.summaryKey)) {
        questions.update(event.summaryKey, (value) => [...value, newQuestion]);
      } else {
        questions.addAll({
          event.summaryKey: [newQuestion]
        });
      }

      emit(state.copyWith(questions: questions));

      try {
        final answer = await SummaryRepository().makeRequestFromText(
            userText: event.text, question: event.question);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        print(e);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: null, answerStatus: AnswerStatus.error);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      }
    }, transformer: droppable());

    on<LikeAnswer>((event, emit) {
      final Map<String, List<ResearchQuestion>> questions =
          Map.from(state.questions);
      List<ResearchQuestion> newList =
          List.from(state.questions[event.summaryKey]!);
      newList = newList.map((answer) {
        if (answer.answer == event.answer) {
          return answer.copyWith(like: Like.liked);
        } else {
          return answer;
        }
      }).toList();
      questions.update(event.summaryKey, (value) => [...newList]);
      emit(state.copyWith(questions: questions));
    });

    on<DislikeAnswer>((event, emit) {
      final Map<String, List<ResearchQuestion>> questions =
          Map.from(state.questions);
      List<ResearchQuestion> newList =
          List.from(state.questions[event.summaryKey]!);
      newList = newList.map((answer) {
        if (answer.answer == event.answer) {
          return answer.copyWith(like: Like.disliked);
        } else {
          return answer;
        }
      }).toList();
      questions.update(event.summaryKey, (value) => [...newList]);
      emit(state.copyWith(questions: questions));
    });
  }

  @override
  ResearchState? fromJson(Map<String, dynamic> json) {
    return ResearchState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ResearchState state) {
    return state.toJson();
  }
}
