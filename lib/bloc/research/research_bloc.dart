import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/services/demo_data_initializer.dart';
import 'package:summify/services/demo_research.dart';
import 'package:summify/services/document_api_service.dart';
import 'package:summify/services/summaryApi.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../models/models.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'research_event.dart';
part 'research_bloc.g.dart';
part 'research_state.dart';

class ResearchBloc extends HydratedBloc<ResearchEvent, ResearchState> {
  final MixpanelBloc mixpanelBloc;
  final DocumentApiService _documentApi = DocumentApiService();

  ResearchBloc({required this.mixpanelBloc})
      : super(const ResearchState(questions: {})) {
    on<MakeQuestionFromUrl>((event, emit) async {
      await _handleQuestion(
        summaryKey: event.summaryKey,
        question: event.question,
        serverId: event.serverId,
        fetchAnswer: () => SummaryRepository().makeRequest(
          summaryUrl: event.summaryKey,
          question: event.question,
          systemHint: event.systemHint,
        ),
        systemHint: event.systemHint,
        emit: emit,
      );
    }, transformer: droppable());

    on<MakeQuestionFromFile>((event, emit) async {
      await _handleQuestion(
        summaryKey: event.summaryKey,
        question: event.question,
        serverId: event.serverId,
        fetchAnswer: () => SummaryRepository().makeRequestFromFile(
          filePath: event.filePath,
          question: event.question,
          systemHint: event.systemHint,
        ),
        systemHint: event.systemHint,
        emit: emit,
      );
    }, transformer: droppable());

    on<MakeQuestionFromText>((event, emit) async {
      await _handleQuestion(
        summaryKey: event.summaryKey,
        question: event.question,
        serverId: event.serverId,
        fetchAnswer: () => SummaryRepository().makeRequestFromText(
          userText: event.text,
          question: event.question,
          systemHint: event.systemHint,
        ),
        systemHint: event.systemHint,
        emit: emit,
      );
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

  /// Common handler for all question types. Uses v2 chat when [serverId] is set.
  Future<void> _handleQuestion({
    required String summaryKey,
    required String question,
    required String? serverId,
    required Future<String> Function() fetchAnswer,
    String? systemHint,
    required Emitter<ResearchState> emit,
  }) async {
    final newQuestion = ResearchQuestion(
      question: question,
      answerStatus: AnswerStatus.loading,
      answer: null,
      like: Like.unliked,
    );

    final questions = Map<String, List<ResearchQuestion>>.from(state.questions);
    if (questions.containsKey(summaryKey)) {
      questions.update(summaryKey, (v) => [...v, newQuestion]);
    } else {
      questions[summaryKey] = [newQuestion];
    }
    emit(state.copyWith(questions: questions));

    try {
      String answer;
      if (serverId != null) {
        final msg = await _documentApi.sendMessage(
          serverId,
          question: question,
          systemHint: systemHint,
        );
        answer = msg.answer ?? '';
      } else {
        answer = await fetchAnswer();
      }

      final updated = Map<String, List<ResearchQuestion>>.from(state.questions);
      final list = List<ResearchQuestion>.from(updated[summaryKey]!);
      list.last = newQuestion.copyWith(
        answer: answer,
        answerStatus: AnswerStatus.completed,
      );
      updated[summaryKey] = list;
      emit(state.copyWith(questions: updated));
    } catch (e) {
      mixpanelBloc.add(
        TrackResearchSummary(url: summaryKey, error: e.toString()),
      );
      final updated = Map<String, List<ResearchQuestion>>.from(state.questions);
      final list = List<ResearchQuestion>.from(updated[summaryKey]!);
      list.last = newQuestion.copyWith(
        answer: null,
        answerStatus: AnswerStatus.error,
      );
      updated[summaryKey] = list;
      emit(state.copyWith(questions: updated));
    }
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
