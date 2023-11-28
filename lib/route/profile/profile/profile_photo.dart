import 'package:flutter/material.dart';

const avatarNames = [
  'antoine',
  'cassandra',
  'catherine',
  'charles',
  'claude',
  'gabrielle',
  'hugo',
  'ines',
  'lea',
  'leo',
  'lucas',
  'madeleine',
  'maeva',
  'manu',
  'mathis',
  'nathan',
  'nick',
  'orion',
  'ricardo',
  'victor',
  'yannick',
];

class UserAvatar extends StatelessWidget {
  const UserAvatar(this.photo, {this.backgroundColor, this.radius, super.key});

  final String? photo;
  final Color? backgroundColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      backgroundImage: _getPhotoAsset(photo),
      radius: radius,
    );
  }
}

ImageProvider<Object>? _getPhotoAsset(String? photo) {
  if (photo == null) {
    return null;
  } else if (photo.startsWith('avatar-')) {
    return AssetImage('assets/${photo.replaceAll('-', '/')}.jpg');
  } else {
    return NetworkImage(photo);
  }
}
