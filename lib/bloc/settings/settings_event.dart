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

class SendNotify extends SettingsEvent {
  final String title;
  final String description;

  const SendNotify({required this.title, required this.description});

  @override
  List<String?> get props => [title, description];
}
