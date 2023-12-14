import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';

class Streamer {
  /// Stream a user from its id
  static Widget user({
    required String userId,
    required Widget Function(BuildContext, UserModel) builder,
  }) {
    return StreamBuilder<UserModel?>(
      stream: userCRUD.stream(documentId: userId),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return const CircularProgressIndicator();
        return builder(context, user);
      },
    );
  }
}
