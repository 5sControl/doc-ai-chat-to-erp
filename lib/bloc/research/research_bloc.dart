import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'research_event.dart';
part 'research_state.dart';

class ResearchBloc extends Bloc<ResearchEvent, ResearchState> {
  ResearchBloc() : super(const ResearchState(questions: {})) {
    on<MakeQuestion>((event, emit) {
      final questions = Map.from(state.questions);

      if (!questions.containsKey(event.summaryKey)) {
        questions[event.summaryKey] = [
          const ResearchQuestion(
              question: 'asdasdas',
              answer: ResearchAnswer(
                  answer: null,
                  answerStatus: AnswerStatus.loading,
                  like: Like.unliked))
        ];
      }
    });
  }
}
