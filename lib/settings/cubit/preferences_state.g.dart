// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreferencesStateImpl _$$PreferencesStateImplFromJson(
        Map<String, dynamic> json) =>
    _$PreferencesStateImpl(
      brightness: $enumDecode(_$BrightnessEnumMap, json['brightness']),
      languageCode: json['language_code'] as String,
      seedColor: json['seed_color'] as String,
    );

Map<String, dynamic> _$$PreferencesStateImplToJson(
        _$PreferencesStateImpl instance) =>
    <String, dynamic>{
      'brightness': _$BrightnessEnumMap[instance.brightness]!,
      'language_code': instance.languageCode,
      'seed_color': instance.seedColor,
    };

const _$BrightnessEnumMap = {
  Brightness.dark: 'dark',
  Brightness.light: 'light',
};
