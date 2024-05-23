part of 'settings_bloc.dart';

enum AppTheme { auto, dark, light }

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;
  final bool howToShowed;
  final String abTest;
  final bool isNotificationsEnabled;
  final AppTheme appTheme;
  final bool subscriptionsSynced;
  final String translateLanguage;
  final int fontSize;

  const SettingsState(
      {required this.onboardingPassed,
      required this.howToShowed,
      required this.abTest,
      required this.isNotificationsEnabled,
      required this.appTheme,
      required this.subscriptionsSynced,
      required this.translateLanguage,
      required this.fontSize});

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
    String? abTest,
    bool? isNotificationsEnabled,
    AppTheme? appTheme,
    ThemeMode? themeMode,
    bool? subscriptionsSynced,
    String? translateLanguage,
    int? fontSize,
  }) {
    return SettingsState(
        onboardingPassed: onboardingPassed ?? this.onboardingPassed,
        howToShowed: howToShowed ?? this.howToShowed,
        abTest: abTest ?? this.abTest,
        isNotificationsEnabled:
            isNotificationsEnabled ?? this.isNotificationsEnabled,
        appTheme: appTheme ?? this.appTheme,
        subscriptionsSynced: subscriptionsSynced ?? this.subscriptionsSynced,
        translateLanguage: translateLanguage ?? this.translateLanguage,
        fontSize: fontSize ?? this.fontSize);
  }

  @override
  List<Object> get props => [
        onboardingPassed,
        howToShowed,
        abTest,
        isNotificationsEnabled,
        appTheme,
        subscriptionsSynced,
        translateLanguage,
        fontSize
      ];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
