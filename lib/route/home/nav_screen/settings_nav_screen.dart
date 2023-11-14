import 'package:crea_chess/route/home/nav_screen/nav_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsNavCubit extends NavCubit {
  SettingsNavCubit()
      : super(
          subscreens: [
            const SettingsScreen(),
          ],
          initialIndex: 0,
        );
}

class SettingsNavScreen extends NavScreen<SettingsNavCubit> {
  const SettingsNavScreen({super.key});

  @override
  SettingsNavCubit createCubit() => SettingsNavCubit();

  @override
  SettingsNavCubit getCubit(BuildContext context) {
    return context.read<SettingsNavCubit>();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider(
  //     create: (context) => SettingsNavCubit(),
  //     child: BlocBuilder<SettingsNavCubit, int>(
  //       builder: (context, index) {
  //         return getSubScreen(context);
  //       },
  //     ),
  //   );
  // }
}
