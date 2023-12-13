import 'package:flutter/material.dart';

const bannerNames = [
  'clarky_pngtree',
  'deepj_pngtree',
  'wart_pngtree',
  'clack_pxfuel',
  'molg_pngtree',
  'gamble_pngtree',
  'hander_ftcdn',
  'pur_wallpaperflare',
  'sandwitch_pngtree',
  'gold_pinimg',
];

class UserProfileBanner extends StatelessWidget {
  const UserProfileBanner(this.banner, {super.key});

  final String? banner;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Image.asset(
        'assets/banner/$banner.jpg',
        fit: BoxFit.fitWidth,
        errorBuilder: (a, b, c) => const ColoredBox(color: Colors.grey),
      ),
    );
  }
}
