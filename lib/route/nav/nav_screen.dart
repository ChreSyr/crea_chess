import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/route/nav/nav_sub_screen.dart';
import 'package:crea_chess/route/nav/settings/settings_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavCubit extends Cubit<int> {
  NavCubit({required this.subscreens, required int initialIndex})
      : assert(subscreens.isNotEmpty, 'subscreens cannot be empty'),
        super(initialIndex);

  final List<NavSubScreen> subscreens;

  static NavCubit create() {
    return SettingsNavCubit();
  }
}

abstract class NavScreen<T extends NavCubit> extends StatelessWidget {
  const NavScreen({super.key});

  T createCubit();
  T getCubit(BuildContext context);

  Widget wrap(Widget subscreen) {
    return subscreen;
  }

  @override
  Widget build(BuildContext context) {
    final navCubit = createCubit();
    return BlocProvider<T>(
      create: (context) => navCubit,
      child: wrap(
        BlocBuilder<T, int>(
          builder: (context, index) {
            NavSubScreen child;
            try {
              child = navCubit.subscreens[index];
            } catch (_) {
              child = navCubit.subscreens.first;
            }

            return CCPadding.allLarge(
              child: Center(
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
