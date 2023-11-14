import 'package:crea_chess/route/nav/nav_screen.dart';
import 'package:crea_chess/route/nav/play/nav_sub_screen/create_challenge_screen.dart';
import 'package:crea_chess/route/nav/play/nav_sub_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayNavCubit extends NavCubit {
  PlayNavCubit()
      : super(
          subscreens: [
            const HomeScreen(),
            const CreateChallengeScreen(),
          ],
          initialIndex: 0,
        );

  void goHome() => emit(0);
  void goSetup() => emit(1);
}

class PlayNavScreen extends NavScreen<PlayNavCubit> {
  const PlayNavScreen({super.key});

  @override
  PlayNavCubit createCubit() => PlayNavCubit();

  @override
  PlayNavCubit getCubit(BuildContext context) {
    return context.read<PlayNavCubit>();
  }
}
