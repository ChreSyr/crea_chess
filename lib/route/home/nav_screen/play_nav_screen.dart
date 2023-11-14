import 'package:crea_chess/route/home/nav_screen/nav_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/play/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayNavCubit extends NavCubit {
  PlayNavCubit()
      : super(
          subscreens: [
            const HomeScreen(),
          ],
          initialIndex: 0,
        );
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
