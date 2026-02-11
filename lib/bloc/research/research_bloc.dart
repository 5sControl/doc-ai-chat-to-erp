import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/services/demo_data_initializer.dart';
import 'package:summify/services/demo_research.dart';
import 'package:summify/services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../models/models.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'research_event.dart';
part 'research_bloc.g.dart';
part 'research_state.dart';

class ResearchBloc extends HydratedBloc<ResearchEvent, ResearchState> {
  final MixpanelBloc mixpanelBloc;
  ResearchBloc({required this.mixpanelBloc})
      : super(const ResearchState(questions: {})) {
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
          summaryUrl: event.summaryKey,
          question: event.question,
          systemHint: event.systemHint,
        );
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        mixpanelBloc.add(
            TrackResearchSummary(url: event.summaryKey, error: e.toString()));
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
          filePath: event.filePath,
          question: event.question,
          systemHint: event.systemHint,
        );
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        mixpanelBloc.add(
            TrackResearchSummary(url: event.summaryKey, error: e.toString()));
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
          userText: event.text,
          question: event.question,
          systemHint: event.systemHint,
        );
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        final List<ResearchQuestion> newList =
            List.from(state.questions[event.summaryKey]!);
        newList.last = newQuestion.copyWith(
            answer: answer, answerStatus: AnswerStatus.completed);
        questions.update(event.summaryKey, (value) => newList);
        emit(state.copyWith(questions: questions));
      } catch (e) {
        mixpanelBloc.add(
            TrackResearchSummary(url: event.summaryKey, error: e.toString()));
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

    on<InitializeDemoResearch>((event, emit) {
      final existing = state.questions[DemoDataInitializer.demoKey];
      if (existing != null && existing.isNotEmpty) return;

      final demoQuestion = ResearchQuestion(
        question: DemoResearch.demoQuestion,
        answer: DemoResearch.demoAnswer,
        answerStatus: AnswerStatus.completed,
        like: Like.unliked,
      );
      final questions = Map<String, List<ResearchQuestion>>.from(state.questions);
      questions[DemoDataInitializer.demoKey] = [demoQuestion];
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
