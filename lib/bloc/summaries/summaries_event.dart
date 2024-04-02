part of 'summaries_bloc.dart';

sealed class SummariesEvent extends Equatable {
  const SummariesEvent();
}

class GetSummaryFromSharedUrl extends SummariesEvent {
  final String summaryUrl;
  const GetSummaryFromSharedUrl({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class GetSummaryFromSharedText extends SummariesEvent {
  final String text;
  const GetSummaryFromSharedText({required this.text});

  @override
  List<Object?> get props => [text];
}

class GetSummaryFromSharedFile extends SummariesEvent {
  final SharedMediaFile summaryFile;
  const GetSummaryFromSharedFile({required this.summaryFile});

  @override
  List<Object?> get props => [summaryFile];
}

// class GetSummaryFromUrl extends SummariesEvent {
//   final String summaryUrl;
//   const GetSummaryFromUrl({required this.summaryUrl});
//
//   @override
//   List<Object?> get props => [summaryUrl];
// }
//
class LoadSummaryFromFile extends SummariesEvent {
  final String fileName;
  final String filePath;

  const LoadSummaryFromFile({required this.fileName, required this.filePath});

  @override
  List<Object?> get props => [fileName, filePath];
}

class LoadSummaryPreview extends SummariesEvent {
  final String summaryUrl;
  const LoadSummaryPreview({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class StartSummaryLoading extends SummariesEvent {
  final String summaryUrl;
  const StartSummaryLoading({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class LoadSummaryFromUrl extends SummariesEvent {
  final String summaryUrl;
  const LoadSummaryFromUrl({required this.summaryUrl});

  @override
  List<Object?> get props => [summaryUrl];
}

class LoadSummaryFromText extends SummariesEvent {
  final String summaryTitle;
  final String text;
  const LoadSummaryFromText({required this.summaryTitle, required this.text});

  @override
  List<Object?> get props => [text, summaryTitle];
}
