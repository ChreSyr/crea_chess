import 'package:flutter/material.dart';

class CCColor {
  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.background;

  static Color fieldBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.inverseSurface
          : Colors.grey[200]!;

  static Color inverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.inverseSurface;
}
