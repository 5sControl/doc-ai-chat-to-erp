import 'package:bloc/bloc.dart';
import 'package:summify/bloc/offers/offers_event.dart';
import 'package:summify/bloc/offers/offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  static const int totalScreens = 6; // Number of screens

  OffersBloc() : super(const OffersState(0)) {
    on<NextScreenEvent>((event, emit) {
      int nextIndex = (state.screenIndex + 1) % totalScreens;
      emit(OffersState(nextIndex));
    });
  }
}
