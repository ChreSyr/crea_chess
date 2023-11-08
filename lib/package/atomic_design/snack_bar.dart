import 'package:flutter/material.dart';

void _snackBar(
  BuildContext context,
  Widget content, {
  Widget? action,
  bool canClose = true,
  Color color = Colors.red,
  Duration duration = const Duration(seconds: 3),
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: GestureDetector(
            child: Row(
              children: [
                Expanded(child: content),
                if (action != null) action,
                if (canClose)
                  IconButton(
                    color: Colors.white,
                    onPressed: scaffoldMessenger.removeCurrentSnackBar,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
          ),
        ),
        duration: duration,
      ),
    );
}

void snackBarError(BuildContext context, String message) {
  _snackBar(
    context,
    Text(message),
  );
}

void snackBarNotify(BuildContext context, String message) {
  _snackBar(
    context,
    Text(message),
    color: Colors.black38, // TODO: change
  );
}

void snackBarClear(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
