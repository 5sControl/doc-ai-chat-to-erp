import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../models/models.dart';
import '../../services/summaryApi.dart';

part 'translates_event.dart';
part 'translates_state.dart';
part 'translates_bloc.g.dart';

class TranslatesBloc extends HydratedBloc<TranslatesEvent, TranslatesState> {
  TranslatesBloc()
      : super(const TranslatesState(longTranslates: {}, shortTranslates: {})) {
    on<TranslateSummary>((event, emit) async {
      if (event.summaryType == SummaryType.short) {
        final Map<String, SummaryTranslate> translates =
            Map.from(state.shortTranslates);

        translates.addAll({
          event.summaryKey: const SummaryTranslate(
              translate: null,
              translateStatus: TranslateStatus.loading,
              isActive: false)
        });

        emit(state.copyWith(shortTranslates: translates));

        try {
          final res = await SummaryRepository().getTranslate(
              text: event.summaryText, languageCode: event.languageCode);
          final Map<String, SummaryTranslate> translates =
              Map.from(state.shortTranslates);
          translates.update(
              event.summaryKey,
              (translate) => translate.copyWith(
                  translateStatus: TranslateStatus.complete,
                  translate: res,
                  isActive: true));
          emit(state.copyWith(shortTranslates: translates));
        } catch (e) {
          final Map<String, SummaryTranslate> translates =
              Map.from(state.shortTranslates);
          translates.update(
              event.summaryKey,
              (translate) => translate.copyWith(
                  translateStatus: TranslateStatus.error, translate: null));
          emit(state.copyWith(shortTranslates: translates));
        }
      } else {
        final Map<String, SummaryTranslate> translates =
            Map.from(state.longTranslates);

        translates.addAll({
          event.summaryKey: const SummaryTranslate(
              translate: null,
              translateStatus: TranslateStatus.loading,
              isActive: false)
        });

        emit(state.copyWith(longTranslates: translates));

        try {
          final res = await SummaryRepository().getTranslate(
              text: event.summaryText, languageCode: event.languageCode);
          print(res);
          final Map<String, SummaryTranslate> translates =
              Map.from(state.longTranslates);
          translates.update(
              event.summaryKey,
              (translate) => translate.copyWith(
                  translateStatus: TranslateStatus.complete,
                  translate: res,
                  isActive: true));
          emit(state.copyWith(longTranslates: translates));
        } catch (e) {
          print(e);
          final Map<String, SummaryTranslate> translates =
              Map.from(state.longTranslates);
          translates.update(
              event.summaryKey,
              (translate) => translate.copyWith(
                  translateStatus: TranslateStatus.error, translate: null));
          emit(state.copyWith(longTranslates: translates));
        }
      }
    });

    on<ToggleTranslate>((event, emit) {
      if (event.summaryType == SummaryType.short) {
        final Map<String, SummaryTranslate> translates =
            Map.from(state.shortTranslates);
        translates.update(event.summaryKey,
            (value) => value.copyWith(isActive: !value.isActive));
        emit(state.copyWith(shortTranslates: translates));
      } else {
        final Map<String, SummaryTranslate> translates =
            Map.from(state.longTranslates);
        translates.update(event.summaryKey,
            (value) => value.copyWith(isActive: !value.isActive));
        emit(state.copyWith(longTranslates: translates));
      }
    });
  }

  @override
  TranslatesState? fromJson(Map<String, dynamic> json) {
    return TranslatesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TranslatesState state) {
    return state.toJson();
  }
}
