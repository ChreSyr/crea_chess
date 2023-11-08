import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';

abstract class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Icon getIcon();
  String getTitle(AppLocalizations l10n);
}
