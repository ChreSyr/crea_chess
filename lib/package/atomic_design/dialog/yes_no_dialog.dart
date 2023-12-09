import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showYesNoDialog({
  required BuildContext pageContext,
  required String title,
  required Widget content,
  required void Function() onYes,
}) {
  showDialog<AlertDialog>(
    context: pageContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            onPressed: dialogContext.pop,
            label: const Text('Non'), // TODO : l10n
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              onYes();
              dialogContext.pop();
            },
            label: const Text('Oui'), // TODO : l10n
          ),
        ],
      );
    },
  );
}
