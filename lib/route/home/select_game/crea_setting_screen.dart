import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/route/home/select_game/nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreaSettingsScreen extends StatelessWidget {
  const CreaSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          FilledButton(
            onPressed: context.read<NavCubit>().back,
            child: const Text('Back'),
          ),
          CCGap.large,
          const Text('The board size & budget are defined here'),
          CCGap.large,
          FilledButton.icon(
            onPressed: context.read<NavCubit>().next,
            icon: const Icon(Icons.add),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
