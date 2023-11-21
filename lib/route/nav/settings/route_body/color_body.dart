import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// TODO: modal
class ColorBody extends RouteBody {
  const ColorBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.chooseColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: CCSize.large,
        mainAxisSpacing: CCSize.large,
        children: SeedColor.values
            .map(
              (e) => FilledButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  backgroundColor: e.color,
                ),
                onPressed: () {
                  context
                    ..pop()
                    ..read<PreferencesCubit>().setSeedColor(e);
                },
                child: const Text(''),
              ),
            )
            .toList(),
      ),
    );
  }
}
