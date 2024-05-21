import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:summify/services/summaryApi.dart';

import '../../models/models.dart';

part 'research_event.dart';
part 'research_state.dart';

class ResearchBloc extends Bloc<ResearchEvent, ResearchState> {
  ResearchBloc() : super(const ResearchState(questions: {})) {
    on<MakeQuestion>((event, emit) async {
      final question = ResearchQuestion(
          question: event.question,
          answer: const ResearchAnswer(
              answer: null,
              answerStatus: AnswerStatus.loading,
              like: Like.unliked));

      if (!state.questions.containsKey(event.summaryKey)) {
        final Map<String, List<ResearchQuestion>> questions =
            Map.from(state.questions);
        questions[event.summaryKey] = [question];

        emit(state.copyWith(questions: questions));
      } else {
        final Map<String, List<ResearchQuestion>> questionsMap =
            Map.from(state.questions);
        final List<ResearchQuestion> questionsList =
            List.from(state.questions[event.summaryKey]!)..add(question);
        questionsMap.update(event.summaryKey, (value) => questionsList);
        emit(state.copyWith(questions: questionsMap));

        final s = await SummaryRepository().makeRequest(
            summaryUrl: event.summaryKey, question: event.question);

        print(s);
      }
    });
  }
}
