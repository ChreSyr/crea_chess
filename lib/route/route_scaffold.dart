import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';

class RouteScaffold extends StatelessWidget {
  const RouteScaffold({
    required this.body,
    this.withPadding = true,
    super.key,
  });

  final RouteBody body;
  final bool withPadding;

  @override
  Widget build(BuildContext context) {
    Widget padd(Widget child) {
      return withPadding ? CCPadding.horizontalLarge(child: child) : child;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(body.getTitle(context.l10n)),
      ),
      body: padd(
        Center(
          child: SingleChildScrollView(
            child: body,
          ),
        ),
      ),
    );
  }
}
