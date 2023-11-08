import 'package:flutter/material.dart';

class CCPadding extends Padding {
  const CCPadding({
    super.key,
    required super.padding,
    super.child,
  });

  /// padding: const EdgeInsets.all(2),
  factory CCPadding.allXxsmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(2),
      child: child,
    );
  }

  /// padding: const EdgeInsets.all(4),
  factory CCPadding.allXsmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }

  /// padding: const EdgeInsets.all(8),
  factory CCPadding.allSmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }

  /// padding: const EdgeInsets.all(16),
  factory CCPadding.allMedium({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  /// padding: const EdgeInsets.all(32),
  factory CCPadding.allLarge({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(32),
      child: child,
    );
  }

  /// padding: const EdgeInsets.all(64),
  factory CCPadding.allXlarge({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.all(64),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 2),
  factory CCPadding.horizontalXxsmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 4),
  factory CCPadding.horizontalXsmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 8),
  factory CCPadding.horizontalSmall({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 16),
  factory CCPadding.horizontalMedium({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 32),
  factory CCPadding.horizontalLarge({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: child,
    );
  }

  /// padding: const EdgeInsets.symmetric(horizontal: 64),
  factory CCPadding.horizontalXlarge({required Widget child}) {
    return CCPadding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: child,
    );
  }
}
