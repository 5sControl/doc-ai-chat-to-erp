part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;
  final bool howToShowed;
  final String abTest;

  const SettingsState({required this.onboardingPassed, required this.howToShowed, required this.abTest});

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
    String? abTest,
  }) {
    return SettingsState(
      onboardingPassed: onboardingPassed ?? this.onboardingPassed,
      howToShowed: howToShowed ?? this.howToShowed,
        abTest: abTest ?? this.abTest,
    );
  }

  @override
  List<Object> get props => [onboardingPassed, howToShowed, abTest];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
