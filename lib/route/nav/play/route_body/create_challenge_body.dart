import 'package:crea_chess/package/atomic_design/modal/board_size_modal.dart';
import 'package:crea_chess/package/atomic_design/modal/budget_modal.dart';
import 'package:crea_chess/package/atomic_design/modal/time_control_modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/game/time_control.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/play/create_challenge/create_challenge_cubit.dart';
import 'package:crea_chess/route/nav/play/create_challenge/create_challenge_form.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeBody extends RouteBody {
  const CreateChallengeBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return 'Create challenge'; // TODO
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreateChallengeCubit(),
      child: const _CreateChallengeBody(),
    );
  }
}

class _CreateChallengeBody extends StatelessWidget {
  const _CreateChallengeBody();

  @override
  Widget build(BuildContext context) {
    final createChallengeCubit = context.read<CreateChallengeCubit>();
    return BlocBuilder<CreateChallengeCubit, CreateChallengeForm>(
      builder: (context, form) {
        return ListView(
          shrinkWrap: true,
          children: [
            _Custom(
              title: context.l10n.timeControl,
              child: OutlinedButton.icon(
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
            ),
            CCGap.large,
            _Custom(
              title: 'Taille du plateau',
              child: OutlinedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return BoardSizeModal(
                      selected: form.boardSize.value,
                      onSelected: (BoardSize choice) {
                        createChallengeCubit.setBoardSize(choice);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                child: Text(form.boardSize.value.display),
              ),
            ),
            CCGap.large,
            _Custom(
              title: 'Budget',
              child: OutlinedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return BudgetModal(
                      selected: form.budget.value,
                      onSelected: (int choice) {
                        createChallengeCubit.setBudget(choice);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                child: Text(form.budget.value.toString()),
              ),
            ),
            CCGap.large,
            FilledButton(
              onPressed: () {}, // TODO
              child: const Text('Create challenge'), // TODO
            ),
          ],
        );
      },
    );
  }
}

class _Custom extends StatelessWidget {
  const _Custom({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title :'),
        const Expanded(
          child: CCGap.medium,
        ),
        SizedBox(
          width: CCWidgetSize.large,
          child: child,
        ),
      ],
    );
  }
}
