import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/route/home/select_game/nav_cubit.dart';
import 'package:crea_chess/route/play/play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('nav : challenge');
    return Center(
      child: ListView(
        children: [
          const Text('The challenges appear here'),
          CCGap.large,
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<PlayPage>(
                builder: (context) => const PlayPage(),
              ),
            ),
            child: const Text('Play'),
          ),
          CCGap.large,
          FilledButton.icon(
            onPressed: context.read<NavCubit>().next,
            icon: const Icon(Icons.add),
            label: const Text('Create challenge'),
          ),
        ],
      ),
    );
  }
}
