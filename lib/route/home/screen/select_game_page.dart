import 'package:crea_chess/route/home/screen/home_screen.dart';
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
    return Center(
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<PlayPage>(
            builder: (context) => const PlayPage(),
          ),
        ),
        child: const Text('Play'),
      ),
    );
  }
}
