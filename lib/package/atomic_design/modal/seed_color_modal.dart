import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/preferences/preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// TODO: CCModal ?

class SeedColorModal extends StatelessWidget {
  const SeedColorModal({super.key});

  static void show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const SeedColorModal();
        },
      );

  @override
  Widget build(BuildContext context) {
    return CCPadding.allMedium(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.chooseColor,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          CCGap.large,
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
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
        ],
      ),
    );
  }
}
