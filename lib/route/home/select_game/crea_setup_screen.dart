import 'package:crea_chess/package/atomic_design/from_lichess/time_control.dart';
import 'package:crea_chess/package/atomic_design/from_lichess/time_control_modal.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/route/home/create_challenge/create_challenge_cubit.dart';
import 'package:crea_chess/route/home/create_challenge/create_challenge_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreaSetupScreen extends StatelessWidget {
  const CreaSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreateChallengeCubit(),
      child: const _CreaSetupScreen(),
    );
  }
}

class _CreaSetupScreen extends StatelessWidget {
  const _CreaSetupScreen();

  @override
  Widget build(BuildContext context) {
    final createChallengeCubit = context.read<CreateChallengeCubit>();
    return BlocBuilder<CreateChallengeCubit, CreateChallengeForm>(
      builder: (context, form) {
        return CCPadding.allLarge(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: Navigator.of(context).pop,
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
                  icon: Icon(form
                      .timeControl.value.speed.icon), // TODO : timeControl.icon
                  label: Text(form.timeControl.value.display),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
