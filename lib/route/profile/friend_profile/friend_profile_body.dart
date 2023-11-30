import 'package:crea_chess/package/atomic_design/widget/user/user_profile.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:crea_chess/route/router.dart';
import 'package:flutter/material.dart';

class FriendProfileBody extends RouteBody {
  const FriendProfileBody({required this.friendId, super.key});

  final String friendId;

  @override
  String getTitle(AppLocalizations l10n) => '';

  @override
  Widget build(BuildContext context) {
    if (friendId.isEmpty) {
      return ErrorBody(exception: Exception('No friendId provided'));
    }
    return StreamBuilder<UserModel?>(
      stream: userCRUD.stream(documentId: friendId),
      builder: (context, snapshot) {
        final friend = snapshot.data;
        if (friend == null) return const CircularProgressIndicator();
        return _FriendProfileBody(friend: friend);
      },
    );
  }
}

class _FriendProfileBody extends StatelessWidget {
  const _FriendProfileBody({required this.friend});

  final UserModel friend;

  @override
  Widget build(BuildContext context) {
    return UserProfile(user: friend, editable: false);
  }
}
