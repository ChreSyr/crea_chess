// ignore_for_file: invalid_annotation_target

import 'dart:ui';

import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/settings/cubit/preferences_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class PreferencesCubit extends HydratedCubit<PreferencesState> {
  PreferencesCubit()
      : super(PreferencesState(
          brightness: Brightness.dark,
          languageCode: defaultLocale,
            seedColor: SeedColor.lightgreen,
          ),
        );

  void toggleTheme() => emit(state.copyWith(
      brightness: state.brightness == Brightness.light
          ? Brightness.dark
              : Brightness.light,
        ),
      );

  void setDarkTheme() => emit(state.copyWith(brightness: Brightness.dark));

  void setLigthTheme() => emit(state.copyWith(brightness: Brightness.light));

  void setSeedColor(SeedColor seedColor) {
    emit(state.copyWith(seedColor: seedColor));
  }

  void toggleLocale() => emit(
        state.copyWith(languageCode: state.languageCode == 'fr' ? 'en' : 'fr'),
      );

  @override
  PreferencesState? fromJson(Map<String, dynamic> json) {
    return PreferencesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PreferencesState state) {
    return state.toJson();
  }
}
