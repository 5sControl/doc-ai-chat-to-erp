part of 'translates_bloc.dart';

abstract class TranslatesEvent extends Equatable {
  const TranslatesEvent();
}

class TranslateSummary extends TranslatesEvent {
  final String summaryKey;
  final SummaryType summaryType;
  final String summaryText;
  final String languageCode;
  const TranslateSummary(
      {required this.summaryKey,
      required this.summaryType,
      required this.summaryText,
      required this.languageCode});

  @override
  List<Object> get props =>
      [summaryKey, summaryType, summaryText, languageCode];
}

class ToggleTranslate extends TranslatesEvent {
  final String summaryKey;
  final SummaryType summaryType;
  const ToggleTranslate({
    required this.summaryKey,
    required this.summaryType,
  });

  @override
  List<Object> get props => [
        summaryKey,
        summaryType,
      ];
}
