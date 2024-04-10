// import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../services/notify.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.g.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(
            onboardingPassed: false,
            howToShowed: false,
            abTest: (DateTime.now().minute % 2) == 1 ? 'A' : 'B')) {
    on<PassOnboarding>((event, emit) {
      emit(state.copyWith(onboardingPassed: true));
    });

    on<HowToShowed>((event, emit) {
      emit(state.copyWith(howToShowed: true));
    });

    on<SendNotify>((event, emit) {
      Future.delayed(const Duration(seconds: 1), () {
        NotificationService().showNotification(
            title: 'Your summary is ready! Open and get useful insights.',
            body: event.title);
      });
    });
  }

  @override
  SettingsState fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
