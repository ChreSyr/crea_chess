import 'package:crea_chess/package/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:crea_chess/package/preferences/preferences_state.dart';
import 'package:crea_chess/route/home/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreaChessApp extends StatelessWidget {
  const CreaChessApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => PreferencesCubit(),
        ),
      ],
      child: BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (context, preferences) {
          final color = preferences.seedColor.color;
          // seedColors[preferences.seedColor] ?? seedColors['iratusGreen']!;
          return MaterialApp(
            title: 'Crea-Chess Bêta',
            theme: ThemeData(
              useMaterial3: true,
              // TODO: contrasted theme ?
              colorScheme: preferences.brightness == Brightness.dark
                  ? ColorScheme.dark(
                      primary: color,
                      secondary: color,
                    )
                  : ColorScheme.light(primary: color),
            ),
            debugShowCheckedModeBanner: false, // hide debug banner at topleft
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: locales[preferences.languageCode],
            home: const NavPage(),
          );
        },
      ),
    );
  }
}
