part of 'settings_bloc.dart';

enum AppTheme { auto, dark, light }

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;
  final bool howToShowed;
  final String abTest;
  final bool isNotificationsEnabled;
  final AppTheme appTheme;

  const SettingsState({
    required this.onboardingPassed,
    required this.howToShowed,
    required this.abTest,
    required this.isNotificationsEnabled,
    required this.appTheme,
  });

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
    String? abTest,
    bool? isNotificationsEnabled,
    AppTheme? appTheme,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      onboardingPassed: onboardingPassed ?? this.onboardingPassed,
      howToShowed: howToShowed ?? this.howToShowed,
      abTest: abTest ?? this.abTest,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  List<Object> get props => [
        onboardingPassed,
        howToShowed,
        abTest,
        isNotificationsEnabled,
        appTheme,
      ];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
