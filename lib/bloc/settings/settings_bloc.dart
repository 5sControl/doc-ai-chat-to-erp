import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../services/notify.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.g.dart';

const fontSizes = [12, 14, 16, 18, 20, 22];

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final Brightness brightness;

  SettingsBloc({required this.brightness})
      : super(SettingsState(
            onboardingPassed: false,
            howToShowed: false,
            isNotificationsEnabled: true,
            appTheme: AppTheme.auto,
            subscriptionsSynced: false,
            translateLanguage: 'en',
            fontSize: 18,
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

    on<SetPurchasesSync>((event, emit) async {
      emit(state.copyWith(subscriptionsSynced: true));
    });

    on<SetTranslateLanguage>((event, emit) {
      emit(state.copyWith(translateLanguage: event.translateLanguage));
    });

    on<SetUiLocale>((event, emit) {
      emit(state.copyWith(uiLocaleCode: event.uiLocaleCode));
    });

    on<ScaleUpFontSize>((event, emit) {
      if (state.fontSize != fontSizes.last) {
        final nextSize = fontSizes[fontSizes.indexOf(state.fontSize) + 1];
        emit(state.copyWith(fontSize: nextSize));
      }
    });

    on<ScaleDownFontSize>((event, emit) {
      if (state.fontSize != fontSizes.first) {
        final nextSize = fontSizes[fontSizes.indexOf(state.fontSize) - 1];
        emit(state.copyWith(fontSize: nextSize));
      }
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
