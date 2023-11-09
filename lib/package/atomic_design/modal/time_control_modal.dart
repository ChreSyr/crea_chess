import 'package:collection/collection.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/text_style.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/game/speed.dart';
import 'package:crea_chess/package/game/time_control.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TimeControlModal extends StatelessWidget {
  const TimeControlModal({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final TimeControl selected;
  final void Function(TimeControl) onSelected;

  @override
  Widget build(BuildContext context) {
    return CCPadding.allMedium(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CCGap.large,
          Text(
            context.l10n.timeControl,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          CCGap.xlarge,
          _SectionChoices(
            choices: const [
              TimeControl(0, 1),
              TimeControl(60, 0),
              TimeControl(60, 1),
              TimeControl(120, 1),
            ],
            selected: selected,
            title: _SectionTitle(
              title: 'Bullet',
              icon: Speed.bullet.icon,
            ),
            onSelected: onSelected,
          ),
          CCGap.medium,
          _SectionChoices(
            choices: const [
              TimeControl(180, 0),
              TimeControl(180, 2),
              TimeControl(300, 0),
              TimeControl(300, 3),
            ],
            selected: selected,
            title: _SectionTitle(
              title: 'Blitz',
              icon: Speed.blitz.icon,
            ),
            onSelected: onSelected,
          ),
          CCGap.medium,
          _SectionChoices(
            choices: const [
              TimeControl(600, 0),
              TimeControl(600, 5),
              TimeControl(900, 0),
              TimeControl(900, 10),
            ],
            selected: selected,
            title: _SectionTitle(
              title: 'Rapid',
              icon: Speed.rapid.icon,
            ),
            onSelected: onSelected,
          ),
          CCGap.medium,
          _SectionChoices(
            choices: const [
              TimeControl(1500, 0),
              TimeControl(1800, 0),
              TimeControl(1800, 20),
              TimeControl(3600, 0),
            ],
            selected: selected,
            title: const _SectionTitle(
              title: 'Classical',
              icon: Icons.sentiment_satisfied,
            ),
            onSelected: onSelected,
          ),
          CCGap.xxlarge,
        ],
      ),
    );
  }
}

class _SectionChoices extends StatelessWidget {
  const _SectionChoices({
    required this.title,
    required this.choices,
    required this.onSelected,
    required this.selected,
  });

  final TimeControl selected;
  final List<TimeControl> choices;
  final _SectionTitle title;
  final void Function(TimeControl choice) onSelected;

  @override
  Widget build(BuildContext context) {
    final choiceWidgets = choices
        .mapIndexed((index, choice) {
          return [
            Expanded(
              child: ChoiceChip(
                // TODO: back to non contrasted theme ?
                selectedColor: Theme.of(context).colorScheme.primary,
                label: Text(choice.display, style: CCTextStyle.bold),
                selected: selected == choice,
                onSelected: (bool selected) {
                  if (selected) onSelected(choice);
                },
              ),
            ),
            if (index < choices.length - 1) CCGap.small,
          ];
        })
        .flattened
        .toList();

    if (choices.length < 4) {
      final placeHolders = [
        const [CCGap.small],
        for (int i = choices.length; i < 4; i++)
          [
            const Expanded(child: CCGap.small),
            if (i < 3) CCGap.small,
          ],
      ];
      choiceWidgets.addAll(placeHolders.flattened);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        CCGap.small,
        Row(
          children: choiceWidgets,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: CCSize.medium),
        CCGap.medium,
        Text(
          title,
          style: _titleStyle,
        ),
      ],
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: CCSize.medium);
