// ignore_for_file: invalid_annotation_target

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_state.freezed.dart';
part 'preferences_state.g.dart';

@freezed
class PreferencesState with _$PreferencesState {
  factory PreferencesState({
    required Brightness brightness,
    @JsonKey(name: 'language_code') required String languageCode,
    @JsonKey(name: 'seed_color') required String seedColor,
  }) = _PreferencesState;

  factory PreferencesState.fromJson(Map<String, dynamic> json) =>
      _$PreferencesStateFromJson(json);

  /// Required for the override getter
  const PreferencesState._();

  bool get isDarkMode => brightness == Brightness.dark;
}
