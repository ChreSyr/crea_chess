import 'package:crea_chess/route/play/play_page.dart';
import 'package:flutter/material.dart';

class SelectGameScreen extends StatelessWidget {
  const SelectGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlayPage(),
          ),
        ),
        child: const Text('Play'),
      ),
    );
  }
}