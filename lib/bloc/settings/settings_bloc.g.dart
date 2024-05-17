// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    SettingsState(
      onboardingPassed: json['onboardingPassed'] as bool,
      howToShowed: json['howToShowed'] as bool,
      abTest: json['abTest'] as String,
      isNotificationsEnabled: json['isNotificationsEnabled'] as bool,
      appTheme: $enumDecode(_$AppThemeEnumMap, json['appTheme']),
      subscriptionsSynced: json['subscriptionsSynced'] as bool,
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'onboardingPassed': instance.onboardingPassed,
      'howToShowed': instance.howToShowed,
      'abTest': instance.abTest,
      'isNotificationsEnabled': instance.isNotificationsEnabled,
      'appTheme': _$AppThemeEnumMap[instance.appTheme]!,
      'subscriptionsSynced': instance.subscriptionsSynced,
    };

const _$AppThemeEnumMap = {
  AppTheme.auto: 'auto',
  AppTheme.dark: 'dark',
  AppTheme.light: 'light',
};
