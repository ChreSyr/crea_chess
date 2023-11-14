import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/route/home/nav_screen/play_nav_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/nav_sub_screen.dart';
import 'package:crea_chess/route/play/play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends NavSubScreen {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
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
          onPressed: context.read<PlayNavCubit>().goSetup,
          icon: const Icon(Icons.add),
          label: const Text('Create challenge'),
        ),
      ],
    );
  }
}
