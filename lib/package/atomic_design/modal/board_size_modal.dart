import 'package:collection/collection.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/text_style.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:flutter/material.dart';

class BoardSize extends Size {
  const BoardSize(super.width, super.height);

  String get display => '${width.toInt()} x ${height.toInt()}';
}

class BoardSizeModal extends StatelessWidget {
  const BoardSizeModal({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final BoardSize selected;
  final void Function(BoardSize) onSelected;

  @override
  Widget build(BuildContext context) {
    return CCPadding.allMedium(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CCGap.large,
          Text(
            'Taille du plateau',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          CCGap.xlarge,
          _SectionChoices(
            choices: const [
              BoardSize(5, 5),
              BoardSize(6, 6),
              BoardSize(7, 7),
            ],
            selected: selected,
            title: const _SectionTitle(
              title: 'Petit',
            ),
            onSelected: onSelected,
          ),
          CCGap.medium,
          _SectionChoices(
            choices: const [
              BoardSize(8, 8),
              BoardSize(9, 9),
              BoardSize(10, 10),
            ],
            selected: selected,
            title: const _SectionTitle(
              title: 'Grand',
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

  final BoardSize selected;
  final List<BoardSize> choices;
  final _SectionTitle title;
  final void Function(BoardSize choice) onSelected;

  @override
  Widget build(BuildContext context) {
    final choiceWidgets = choices
        .mapIndexed((index, choice) {
          return [
            Expanded(
              child: ChoiceChip(
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
        for (int i = choices.length; i < choices.length; i++)
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
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: _titleStyle,
    );
  }
}

const TextStyle _titleStyle = TextStyle(fontSize: CCSize.medium);
