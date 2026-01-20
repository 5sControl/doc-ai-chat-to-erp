part of 'summaries_bloc.dart';

sealed class SummariesEvent extends Equatable {
  const SummariesEvent();
}

class GetSummaryFromUrl extends SummariesEvent {
  final String summaryUrl;
  final bool fromShare;
  const GetSummaryFromUrl({required this.summaryUrl, required this.fromShare});

  @override
  List<Object?> get props => [summaryUrl, fromShare];
}

class GetSummaryFromText extends SummariesEvent {
  final String text;
  final bool fromShare;
  const GetSummaryFromText({required this.text, this.fromShare = false});

  @override
  List<Object?> get props => [text, fromShare];
}

class GetSummaryFromFile extends SummariesEvent {
  final String fileName;
  final String filePath;
  final bool fromShare;
  const GetSummaryFromFile(
      {required this.fileName,
      required this.filePath,
      required this.fromShare});

  @override
  List<Object?> get props => [fileName, filePath, fromShare];
}

class DeleteSummary extends SummariesEvent {
  final String summaryUrl;
  const DeleteSummary({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class RateSummary extends SummariesEvent {
  final String summaryUrl;
  final int rate;
  final String device;
  final String comment;
  const RateSummary({
    required this.summaryUrl,
    required this.rate,
    required this.device,
    required this.comment,
  });

  @override
  List<Object?> get props => [summaryUrl, rate, device, comment];
}

class SkipRateSummary extends SummariesEvent {
  final String summaryUrl;
  const SkipRateSummary({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class CancelRequest extends SummariesEvent {
  final String sharedLink;
  const CancelRequest({required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}

class IncrementFreeSummaries extends SummariesEvent {
  const IncrementFreeSummaries();

  @override
  List<String?> get props => [];
}

class UnlockHiddenSummaries extends SummariesEvent {
  const UnlockHiddenSummaries();

  @override
  List<Object?> get props => [];
}

class InitializeDemo extends SummariesEvent {
  const InitializeDemo();

  @override
  List<Object?> get props => [];
}
