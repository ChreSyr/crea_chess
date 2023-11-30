import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';

class RouteScaffold extends StatelessWidget {
  const RouteScaffold({
    required this.body,
    super.key,
  });

  final RouteBody body;

  @override
  Widget build(BuildContext context) {
    Widget padd(Widget child, {required bool centered, required bool padded}) {
      final temp = centered ? Center(child: child) : child;
      return padded ? CCPadding.horizontalLarge(child: temp) : temp;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(body.getTitle(context.l10n)),
        actions: body.getActions(context),
      ),
      body: padd(
        centered: body.centered,
        padded: body.centered,
        SingleChildScrollView(
          child: body,
        ),
      ),
    );
  }
}
