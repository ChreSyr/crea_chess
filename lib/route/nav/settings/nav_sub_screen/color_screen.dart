import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:crea_chess/route/nav/nav_sub_screen.dart';
import 'package:crea_chess/route/nav/settings/settings_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorScreen extends NavSubScreen {
  const ColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CCGap.large,
        Center(
          child: Text(
            context.l10n.chooseColor,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        CCPadding.allXlarge(
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
                      context.read<PreferencesCubit>().setSeedColor(e);
                      context.read<SettingsNavCubit>().goSettings();
                    },
                    child: const Text(''),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
