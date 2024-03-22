part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class PassOnboarding extends SettingsEvent {
  const PassOnboarding();

  @override
  List<Object?> get props => [];
}

class HowToShowed extends SettingsEvent {
  const HowToShowed();

  @override
  List<Object?> get props => [];
}
