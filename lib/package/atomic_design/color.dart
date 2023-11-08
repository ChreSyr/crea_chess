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

enum SeedColor {
  lightgreen(Color.fromRGBO(131, 174, 131, 1)),
  green(Color.fromRGBO(12, 163, 12, 1)),
  blue(Color.fromRGBO(71, 234, 255, 1)),
  pink(Color.fromRGBO(255, 58, 206, 1)),
  yellow(Color.fromARGB(255, 255, 233, 34)),
  orange(Color.fromARGB(255, 255, 136, 0));

  const SeedColor(this.color);

  final Color color;
}
