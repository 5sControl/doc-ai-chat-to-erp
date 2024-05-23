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

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications();

  @override
  List<String?> get props => [];
}

class SelectAppTheme extends SettingsEvent {
  final AppTheme appTheme;
  const SelectAppTheme({required this.appTheme});

  @override
  List<Object> get props => [appTheme];
}

class SetPurchasesSync extends SettingsEvent {
  const SetPurchasesSync();

  @override
  List<Object> get props => [];
}

class SetTranslateLanguage extends SettingsEvent {
  final String translateLanguage;
  const SetTranslateLanguage({required this.translateLanguage});

  @override
  List<Object> get props => [translateLanguage];
}

class ScaleUpFontSize extends SettingsEvent {
  const ScaleUpFontSize();

  @override
  List<Object> get props => [];
}

class ScaleDownFontSize extends SettingsEvent {
  const ScaleDownFontSize();

  @override
  List<Object> get props => [];
}