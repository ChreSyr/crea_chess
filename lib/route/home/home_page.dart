import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/home/screen/profile_screen.dart';
import 'package:crea_chess/route/home/screen/select_game_page.dart';
import 'package:crea_chess/route/home/screen/settings_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class _NavigationCubit extends Cubit<int> {
  _NavigationCubit(super.initialeState);

  void set(int val) => emit(val);
}

const defaultScreenIndex = 0;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final PageController pageController = PageController(
    initialPage: defaultScreenIndex,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _NavigationCubit(defaultScreenIndex),
      child: BlocBuilder<_NavigationCubit, int>(
        builder: (context, pageIndex) {
          var navCubit = context.read<_NavigationCubit>();
          return Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: navCubit.set,
              // TODO : HomeScreen.getIcon / getLabel / getTitle
              children: const <Widget>[
                SelectGameScreen(),
                ProfileScreen(),
                SettingsScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.play_arrow), // stadia_controller
                  label: context.l10n.play,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: context.l10n.profile,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: context.l10n.settings,
                ),
              ],
              onTap: (newPageIndex) {
                pageController.animateToPage(
                  newPageIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              type: BottomNavigationBarType.fixed, // even space between items
            ),
          );
        },
      ),
    );
  }
}
