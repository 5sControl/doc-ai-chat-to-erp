part of 'summaries_bloc.dart';

@JsonSerializable()
class SummariesState extends Equatable {
  final Map<String, SummaryData> summaries;
  final Set<String> ratedSummaries;
  // final int dailyLimit;
  // final Map<String, int> dailySummariesMap;
  final int textCounter;
  final SummaryType defaultSummaryType;
  final int freeSummariesUsedToday;
  final String lastFreeSummaryDate;
  final int giftBalance;
  final Set<String> redeemedGiftCodes;
  final String? lastRedeemMessage;

  const SummariesState({
    required this.summaries,
    required this.ratedSummaries,
    required this.textCounter,
    required this.defaultSummaryType,
    required this.freeSummariesUsedToday,
    required this.lastFreeSummaryDate,
    this.giftBalance = 0,
    this.redeemedGiftCodes = const {},
    this.lastRedeemMessage,
  });

  SummariesState copyWith({
    Map<String, SummaryData>? summaries,
    Set<String>? ratedSummaries,
    int? textCounter,
    SummaryType? defaultSummaryType,
    int? freeSummariesUsedToday,
    String? lastFreeSummaryDate,
    int? giftBalance,
    Set<String>? redeemedGiftCodes,
    String? lastRedeemMessage,
    bool clearRedeemMessage = false,
  }) {
    return SummariesState(
      summaries: summaries ?? this.summaries,
      ratedSummaries: ratedSummaries ?? this.ratedSummaries,
      textCounter: textCounter ?? this.textCounter,
      defaultSummaryType: defaultSummaryType ?? this.defaultSummaryType,
      freeSummariesUsedToday:
          freeSummariesUsedToday ?? this.freeSummariesUsedToday,
      lastFreeSummaryDate: lastFreeSummaryDate ?? this.lastFreeSummaryDate,
      giftBalance: giftBalance ?? this.giftBalance,
      redeemedGiftCodes: redeemedGiftCodes ?? this.redeemedGiftCodes,
      lastRedeemMessage:
          clearRedeemMessage ? null : (lastRedeemMessage ?? this.lastRedeemMessage),
    );
  }

  factory SummariesState.fromJson(Map<String, dynamic> json) =>
      _$SummariesStateFromJson(json);

  Map<String, dynamic> toJson() => _$SummariesStateToJson(this);

  @override
  List<Object?> get props => [
        summaries,
        ratedSummaries,
        textCounter,
        defaultSummaryType,
        freeSummariesUsedToday,
        lastFreeSummaryDate,
        giftBalance,
        redeemedGiftCodes,
        lastRedeemMessage,
      ];
}
