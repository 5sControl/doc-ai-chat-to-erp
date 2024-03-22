part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;
  final bool howToShowed;

  const SettingsState({required this.onboardingPassed, required this.howToShowed});

  SettingsState copyWith({
    bool? onboardingPassed,
    bool? howToShowed,
  }) {
    return SettingsState(
      onboardingPassed: onboardingPassed ?? this.onboardingPassed,
      howToShowed: howToShowed ?? this.howToShowed,
    );
  }

  @override
  List<Object> get props => [onboardingPassed, howToShowed];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
