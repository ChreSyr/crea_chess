import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/nav_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _NavigationCubit extends Cubit<int> {
  _NavigationCubit(super.initialeState);

  void set(int val) => emit(val);
}

const defaultScreenIndex = 0;

class NavPage extends StatelessWidget {
  const NavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _NavigationCubit(defaultScreenIndex),
      child: BlocBuilder<_NavigationCubit, int>(
        builder: (context, pageIndex) {
          final navCubit = context.read<_NavigationCubit>();
          return Scaffold(
            body: IndexedStack(
              index: pageIndex,
              children:
                  NavTab.values.map((e) => e.navScreen(context.l10n)).toList(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageIndex,
              items: NavTab.values
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: Icon(e.iconData),
                      label: e.label(context.l10n),
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
