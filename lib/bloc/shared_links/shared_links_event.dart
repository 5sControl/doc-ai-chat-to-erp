part of 'shared_links_bloc.dart';

abstract class SharedLinksEvent extends Equatable {
  const SharedLinksEvent();
}

// class SaveSharedItem extends SharedLinksEvent {
//   final SharedMediaItem sharedItem;
//
//   const SaveSharedItem({required this.sharedItem});
//
//   @override
//   List<Object?> get props => [sharedItem];
// }

class SaveSharedLink extends SharedLinksEvent {
  final String sharedLink;

  const SaveSharedLink({required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}

class SaveText extends SharedLinksEvent {
  final String text;
  const SaveText({required this.text});

  @override
  List<String?> get props => [text];
}

class SaveFile extends SharedLinksEvent {
  final String fileName;
  final String filePath;
  const SaveFile({required this.fileName, required this.filePath});

  @override
  List<String?> get props => [fileName, filePath];
}

class DeleteSharedLink extends SharedLinksEvent {
  final String sharedLink;

  const DeleteSharedLink({required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}

class CancelRequest extends SharedLinksEvent {
  final String? sharedLink;
  const CancelRequest({this.sharedLink});

  @override
  List<String?> get props => [];
}

class SetSummaryOpened extends SharedLinksEvent {
  final String sharedLink;
  const SetSummaryOpened({required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}

class RateSummary extends SharedLinksEvent {
  final String sharedLink;
  final int rate;
  final String comment;
  final String device;
  const RateSummary(
      {required this.rate,
      required this.comment,
      required this.device,
      required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}

class SkipRateSummary extends SharedLinksEvent {
  final String sharedLink;
  const SkipRateSummary({required this.sharedLink});

  @override
  List<String?> get props => [sharedLink];
}
