import 'package:crea_chess/route/home/home_page.dart';
import 'package:crea_chess/l10n/l10n.dart';
import 'package:crea_chess/settings/cubit/preferences_cubit.dart';
import 'package:crea_chess/settings/cubit/preferences_state.dart';
import 'package:crea_chess/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreaChessApp extends StatelessWidget {
  const CreaChessApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => PreferencesCubit(),
      child: BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (context, preferences) {
          final color =
              seedColors[preferences.seedColor] ?? seedColors['iratusGreen']!;
          return MaterialApp(
            title: 'Crea-Chess Bêta',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: preferences.brightness == Brightness.dark
                  ? ColorScheme.highContrastDark(
                      primary: color, secondary: color)
                  : ColorScheme.highContrastLight(primary: color),
            ),
            debugShowCheckedModeBanner: false, // hide debug banner at topleft
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: locales[preferences.languageCode],
            home: HomePage(),
          );
        },
      ),
    );
  }
}
