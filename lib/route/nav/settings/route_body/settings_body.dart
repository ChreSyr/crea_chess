import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/box.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/l10n/get_locale_flag.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:crea_chess/package/preferences/preferences_state.dart';
import 'package:crea_chess/package/atomic_design/modal/seed_color_modal.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsBody extends MainRouteBody {
  const SettingsBody({super.key});

  @override
  Icon getIcon() {
    return const Icon(Icons.settings);
  }

  @override
  String getId() {
    return 'settings';
  }

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.settings;
  }

  @override
  Widget build(BuildContext context) {
    final preferencesCubit = context.read<PreferencesCubit>();

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, preferences) {
        return Column(
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
                onPressed: () => SeedColorModal.show(context),
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
        );
      },
    );
  }
}
