// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      onboardingPassed: json['onboardingPassed'] as bool,
      howToShowed: json['howToShowed'] as bool,
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'onboardingPassed': instance.onboardingPassed,
      'howToShowed': instance.howToShowed,
    };
