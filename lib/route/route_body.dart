import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';

abstract class RouteBody extends StatelessWidget {
  const RouteBody({super.key});

  String getTitle(AppLocalizations l10n);
}

abstract class MainRouteBody extends RouteBody {
  const MainRouteBody({super.key});

  Icon getIcon();
  String getId();
}
