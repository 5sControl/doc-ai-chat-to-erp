part of 'settings_bloc.dart';

@JsonSerializable()
class SettingsState extends Equatable {
  final bool onboardingPassed;

  const SettingsState({required this.onboardingPassed});

  SettingsState copyWith({
    bool? onboardingPassed,
  }) {
    return SettingsState(
      onboardingPassed: onboardingPassed ?? this.onboardingPassed,
    );
  }

  @override
  List<Object> get props => [onboardingPassed];

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}
