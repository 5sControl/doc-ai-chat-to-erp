import 'package:bloc/bloc.dart';
import 'package:summify/bloc/offers/offers_event.dart';
import 'package:summify/bloc/offers/offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(const OffersState(0)) {
    on<NextScreenEvent>((event, emit) {
      int nextIndex = (state.screenIndex + 1) % 6; // Assuming 6 screens
      emit(OffersState(nextIndex));
    });
  }
}
