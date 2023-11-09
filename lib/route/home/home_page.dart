import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/home/screen/home_screen.dart';
import 'package:crea_chess/route/home/screen/profile_screen.dart';
import 'package:crea_chess/route/home/select_game/select_game_page.dart';
import 'package:crea_chess/route/home/screen/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class _NavigationCubit extends Cubit<int> {
  _NavigationCubit(super.initialeState);

  void set(int val) => emit(val);
}

const defaultScreenIndex = 0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const screens = <HomeScreen>[
      SelectGameScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];

    return BlocProvider(
      create: (context) => _NavigationCubit(defaultScreenIndex),
      child: BlocBuilder<_NavigationCubit, int>(
        builder: (context, pageIndex) {
          final navCubit = context.read<_NavigationCubit>();
          return Scaffold(
            body: IndexedStack(
              index: pageIndex,
              children: screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageIndex,
              items: screens
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: e.getIcon(),
                      label: e.getTitle(context.l10n),
                    ),
                  )
                  .toList(),
              onTap: navCubit.set,
              type: BottomNavigationBarType.fixed, // even space between items
            ),
          );
        },
      ),
    );
  }
}
