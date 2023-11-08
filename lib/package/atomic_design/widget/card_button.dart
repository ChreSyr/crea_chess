import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/border.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: CCBorderRadiusCircular.medium,
      clipBehavior: Clip.antiAlias,
      color: CCColor.fieldBackground(context),
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}