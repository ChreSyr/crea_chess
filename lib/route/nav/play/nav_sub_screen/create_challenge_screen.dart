import 'package:crea_chess/package/atomic_design/modal/time_control_modal.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/game/time_control.dart';
import 'package:crea_chess/route/nav/nav_sub_screen.dart';
import 'package:crea_chess/route/nav/play/create_challenge/create_challenge_cubit.dart';
import 'package:crea_chess/route/nav/play/create_challenge/create_challenge_form.dart';
import 'package:crea_chess/route/nav/play/play_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeScreen extends NavSubScreen {
  const CreateChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreateChallengeCubit(),
      child: const _CreateChallengeScreen(),
    );
  }
}

class _CreateChallengeScreen extends StatelessWidget {
  const _CreateChallengeScreen();

  @override
  Widget build(BuildContext context) {
    final createChallengeCubit = context.read<CreateChallengeCubit>();
    return BlocBuilder<CreateChallengeCubit, CreateChallengeForm>(
      builder: (context, form) {
        return ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: context.read<PlayNavCubit>().goHome,
                  child: const Text('Back'),
                ),
                CCGap.large,
                FilledButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
            CCGap.large,
            OutlinedButton.icon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return TimeControlModal(
                    selected: form.timeControl.value,
                    onSelected: (TimeControl choice) {
                      createChallengeCubit.setTimeControl(choice);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
              icon: Icon(form.timeControl.value.speed.icon),
              label: Text(form.timeControl.value.display),
            ),
          ],
        );
      },
    );
  }
}
