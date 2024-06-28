part of 'library_bloc.dart';

class LibraryState extends Equatable {
  final Map<String, LibraryDocument> libraryDocuments;

  const LibraryState({required this.libraryDocuments});

  @override
  List<Object?> get props => [libraryDocuments];
}
