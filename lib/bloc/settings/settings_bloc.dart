import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../services/notify.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.g.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final Brightness brightness;

  SettingsBloc({required this.brightness})
      : super(SettingsState(
            onboardingPassed: false,
            howToShowed: false,
            isNotificationsEnabled: true,
            appTheme: AppTheme.auto,
            subscriptionsSynced: false,
            // themeMode: ThemeMode.system,
            abTest: (DateTime.now().minute % 2) == 1 ? 'A' : 'B')) {
    on<PassOnboarding>((event, emit) {
      emit(state.copyWith(onboardingPassed: true));
    });

    on<HowToShowed>((event, emit) {
      emit(state.copyWith(howToShowed: true));
    });

    on<SendNotify>((event, emit) {
      if (state.isNotificationsEnabled) {
        Future.delayed(const Duration(seconds: 1), () {
          NotificationService().showNotification(
              title: 'Your summary is ready! Open and get useful insights.',
              body: event.title);
        });
      }
    });

    on<ToggleNotifications>((event, emit) {
      emit(state.copyWith(
          isNotificationsEnabled: !state.isNotificationsEnabled));
    });

    on<SelectAppTheme>((event, emit) async {
      emit(state.copyWith(
        appTheme: event.appTheme,
      ));
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
