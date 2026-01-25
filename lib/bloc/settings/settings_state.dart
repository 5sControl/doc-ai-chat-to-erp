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
  @JsonKey(defaultValue: 'system')
  final String uiLocaleCode;
  final int fontSize;
  @JsonKey(defaultValue: 'af')
  final String kokoroVoiceId;
  @JsonKey(defaultValue: 1.0)
  final double kokoroSynthesisSpeed;

  const SettingsState({
    required this.onboardingPassed,
    required this.howToShowed,
    required this.abTest,
    required this.isNotificationsEnabled,
    required this.appTheme,
    required this.subscriptionsSynced,
    required this.translateLanguage,
    this.uiLocaleCode = 'system',
    required this.fontSize,
    required this.kokoroVoiceId,
    required this.kokoroSynthesisSpeed,
  });

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
    String? abTest,
    bool? isNotificationsEnabled,
    AppTheme? appTheme,
    ThemeMode? themeMode,
    bool? subscriptionsSynced,
    String? translateLanguage,
    String? uiLocaleCode,
    int? fontSize,
    String? kokoroVoiceId,
    double? kokoroSynthesisSpeed,
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
      uiLocaleCode: uiLocaleCode ?? this.uiLocaleCode,
      fontSize: fontSize ?? this.fontSize,
      kokoroVoiceId: kokoroVoiceId ?? this.kokoroVoiceId,
      kokoroSynthesisSpeed: kokoroSynthesisSpeed ?? this.kokoroSynthesisSpeed,
    );
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
    uiLocaleCode,
    fontSize,
    kokoroVoiceId,
    kokoroSynthesisSpeed,
  ];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
