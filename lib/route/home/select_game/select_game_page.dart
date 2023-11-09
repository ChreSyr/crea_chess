import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/route/home/screen/home_screen.dart';
import 'package:crea_chess/route/home/select_game/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectGameScreen extends HomeScreen {
  const SelectGameScreen({super.key});

  @override
  Icon getIcon() => const Icon(Icons.play_arrow);

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.play;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavCubit(),
      child: BlocBuilder<NavCubit, int>(
        builder: (context, index) {
          return CCPadding.horizontalLarge(
            child: Center(
              child: NavCubit.screens[index],
            ),
          );
        },
      ),
    );
  }
}
