import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/home/nav_screen/nav_screen.dart';
import 'package:crea_chess/route/home/nav_screen/play_nav_screen.dart';
import 'package:crea_chess/route/home/nav_screen/profile_nav_screen.dart';
import 'package:crea_chess/route/home/nav_screen/settings_nav_screen.dart';
import 'package:flutter/material.dart';

enum NavTab {
  play(Icons.play_arrow),
  profile(Icons.person),
  settings(Icons.settings);

  const NavTab(this.iconData);

  final IconData iconData;

  String label(AppLocalizations l10n) {
    switch (this) {
      case NavTab.play:
        return l10n.play;
      case NavTab.profile:
        return l10n.profile;
      case NavTab.settings:
        return l10n.settings;
    }
  }

  NavScreen screen(AppLocalizations l10n) {
    switch (this) {
      case NavTab.play:
        return const PlayNavScreen();
      case NavTab.profile:
        return const ProfileNavScreen();
      case NavTab.settings:
        return const SettingsNavScreen();
    }
  }
}
