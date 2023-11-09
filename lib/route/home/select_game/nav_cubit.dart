import 'package:crea_chess/route/home/select_game/challenge_screen.dart';
import 'package:crea_chess/route/home/select_game/crea_setting_screen.dart';
import 'package:crea_chess/route/home/select_game/crea_setup_screen.dart';
import 'package:crea_chess/route/home/select_game/game_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  static final List<Widget> screens = [
    const ChallengeScreen(),
    const CreaSettingsScreen(),
    const CreaSetupScreen(),
    const GameScreen(),
  ];

  void back() => emit(state > 0 ? state - 1 : state);
  void next() => emit(state < screens.length - 1 ? state + 1 : state);
}
