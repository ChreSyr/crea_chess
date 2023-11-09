import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/box.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/l10n/get_locale_flag.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:crea_chess/package/preferences/preferences_state.dart';
import 'package:crea_chess/route/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends HomeScreen {
  const SettingsScreen({super.key});

  @override
  Icon getIcon() => const Icon(Icons.settings);

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.settings;
  }

  @override
  Widget build(BuildContext context) {
    final preferencesCubit = context.read<PreferencesCubit>();

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, preferences) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CCSmallBox(
                child: FilledButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: preferencesCubit.toggleTheme,
                  child: Icon(
                    preferences.isDarkMode ? Icons.nightlight : Icons.sunny,
                    size: 50,
                  ),
                ),
              ),
              CCGap.large,
              CCSmallBox(
                child: FilledButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    backgroundColor: preferences.seedColor.color,
                  ),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: SelectSeedColorScreen(),
                      );
                    },
                  ),
                  child: const Text(''),
                ),
              ),
              CCGap.large,
              CCSmallBox(
                child: FilledButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: preferencesCubit.toggleLocale,
                  child: Text(
                    getLocaleFlag(
                      Localizations.localeOf(context).languageCode,
                    ),
                    style: const TextStyle(
                      fontSize: CCSize.xxlarge,
                      fontFamily: 'NotoColorEmoji',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SelectSeedColorScreen extends StatelessWidget {
  const SelectSeedColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CCGap.large,
        Center(
          child: Text(
            context.l10n.chooseColor,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        CCPadding.allXlarge(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: CCSize.large,
            mainAxisSpacing: CCSize.large,
            children: SeedColor.values
                .map(
                  (e) => FilledButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      backgroundColor: e.color,
                    ),
                    onPressed: () {
                      context.read<PreferencesCubit>().setSeedColor(e);
                      Navigator.pop(context);
                    },
                    child: const Text(''),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
