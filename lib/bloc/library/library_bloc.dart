import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/models/models.dart';

import 'library_documents.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc()
      : super(const LibraryState(libraryDocuments: libraryDocuments)) {
    on<LibraryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
