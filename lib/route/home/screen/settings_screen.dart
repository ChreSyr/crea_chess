import 'package:crea_chess/package/l10n/get_locale_flag.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/settings/cubit/preferences_cubit.dart';
import 'package:crea_chess/settings/cubit/preferences_state.dart';
import 'package:crea_chess/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO : download flag emoji locally, shouldn't need internet
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesCubit = context.read<PreferencesCubit>();

    Widget buildRoundButton(String colorName, BuildContext context) {
      // TODO : SeedColor.lightgreen
      return SizedBox(
        height: 80,
        width: 80,
        child: FilledButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              backgroundColor: seedColors[colorName],
            ),
            onPressed: () {
              preferencesCubit.setSeedColor(colorName);
              Navigator.pop(context);
            },
            child: const Text('')),
      );
    }

    void showOptionsDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(child: Text(context.l10n.chooseColor)),
            children: <Widget>[
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRoundButton("iratusGreen", context),
                  const SizedBox(width: 20),
                  buildRoundButton("green", context),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRoundButton("blue", context),
                  const SizedBox(width: 20),
                  buildRoundButton("pink", context),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRoundButton("yellow", context),
                  const SizedBox(width: 20),
                  buildRoundButton("orange", context),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      );
    }

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, preferences) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: FilledButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    preferencesCubit.toggleTheme();
                  },
                  child: Icon(
                    preferences.isDarkMode ? Icons.nightlight : Icons.sunny,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                width: 80,
                child: FilledButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      backgroundColor: seedColors[preferences.seedColor],
                    ),
                    onPressed: () {
                      showOptionsDialog(context);
                    },
                    child: const Text('')),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                width: 80,
                child: FilledButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      preferencesCubit.toggleLocale();
                    },
                    child: Text(
                        getLocaleFlag(
                            Localizations.localeOf(context).languageCode),
                        style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'NotoColorEmoji',
                        ))),
              ),
            ],
          ),
        );
      },
    );
  }
}
