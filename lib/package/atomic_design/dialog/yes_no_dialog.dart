import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showYesNoDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required void Function() onYes,
}) {
  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
            label: const Text('Non'), // TODO : l10n
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: onYes,
            label: const Text('Oui'), // TODO : l10n
          ),
        ],
      );
    },
  );
}
