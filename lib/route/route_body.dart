import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';

abstract class RouteBody extends StatelessWidget {
  const RouteBody({super.key});

  String getTitle(AppLocalizations l10n);

  List<Widget>? getActions(BuildContext context) => null;
}

abstract class MainRouteBody extends RouteBody {
  const MainRouteBody({required this.id, required this.icon, super.key});

  final String id;
  final IconData icon;
}
