import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:flutter/material.dart';

class Modal {
  static void show({
    required BuildContext context,
    required String title,
    required Iterable<Widget> sections,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CCPadding.allMedium(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CCGap.large,
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              CCGap.xlarge,
              ...sections,
              CCGap.xlarge,
            ],
          ),
        );
      },
    );
  }
}
