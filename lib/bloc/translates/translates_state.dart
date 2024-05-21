part of 'translates_bloc.dart';

@JsonSerializable()
class TranslatesState extends Equatable {
  final Map<String, SummaryTranslate> shortTranslates;
  final Map<String, SummaryTranslate> longTranslates;

  const TranslatesState(
      {required this.shortTranslates, required this.longTranslates});

  TranslatesState copyWith({
    Map<String, SummaryTranslate>? shortTranslates,
    Map<String, SummaryTranslate>? longTranslates,
  }) {
    return TranslatesState(
      shortTranslates: shortTranslates ?? this.shortTranslates,
      longTranslates: longTranslates ?? this.longTranslates,
    );
  }


  factory TranslatesState.fromJson(Map<String, dynamic> json) =>
      _$TranslatesStateFromJson(json);

  Map<String, dynamic> toJson() => _$TranslatesStateToJson(this);

  @override
  List<Object> get props => [shortTranslates, longTranslates];
}
