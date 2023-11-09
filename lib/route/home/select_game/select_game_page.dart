import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/route/home/screen/home_screen.dart';
import 'package:crea_chess/route/home/select_game/crea_setup_screen.dart';
import 'package:crea_chess/route/play/play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectGameScreen extends HomeScreen {
  const SelectGameScreen({super.key});

  @override
  Icon getIcon() => const Icon(Icons.play_arrow);

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.play;
  }

  @override
  Widget build(BuildContext context) {
    return CCPadding.allLarge(
      child: Center(
        child: ListView(
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
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreaSetupScreen(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Create challenge'),
            ),
          ],
        ),
      ),
    );
  }
}
