import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:summify/services/summaryApi.dart';

import '../../models/models.dart';

part 'research_event.dart';
part 'research_state.dart';

class ResearchBloc extends Bloc<ResearchEvent, ResearchState> {
  ResearchBloc() : super(const ResearchState(questions: {})) {
    on<MakeQuestion>((event, emit) async {
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
        print(answer.length);
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final question = newQuestion.copyWith(
            answerStatus: AnswerStatus.error, answer: null);
        questions[event.summaryKey]!.last = question;
        emit(state.copyWith(questions: questions));
      }
    });

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
}
