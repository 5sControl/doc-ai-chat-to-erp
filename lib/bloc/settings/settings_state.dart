part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;
  final bool howToShowed;
  final String abTest;
  final bool isNotificationsEnabled;

  const SettingsState(
      {required this.onboardingPassed,
      required this.howToShowed,
      required this.abTest,
      required this.isNotificationsEnabled});

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
    String? abTest,
    bool? isNotificationsEnabled,
  }) {
    return SettingsState(
        onboardingPassed: onboardingPassed ?? this.onboardingPassed,
        howToShowed: howToShowed ?? this.howToShowed,
        abTest: abTest ?? this.abTest,
        isNotificationsEnabled:
            isNotificationsEnabled ?? this.isNotificationsEnabled);
  }

  @override
  List<Object> get props => [onboardingPassed, howToShowed, abTest, isNotificationsEnabled];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
