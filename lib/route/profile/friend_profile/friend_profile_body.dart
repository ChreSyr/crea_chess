import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/user/friend_preview.Dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
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
    return SizedBox(
      width: CCWidgetSize.large3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.transparent),
            title: Center(
              child: UserProfilePhoto(
                friend.photo,
                radius: CCSize.xxxlarge,
                backgroundColor: friend.photo == null ? Colors.grey : null,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: Text(friend.username ?? ''),
          ),
          CCDivider.xthin,
          ListTile(
            leading: const Icon(Icons.groups),
            title: Text(context.l10n.friends),
          ),
          StreamBuilder<List<RelationshipModel>>(
            stream: relationshipCRUD.of(friend.id),
            builder: (context, snapshot) {
              final relations = snapshot.data;
              return Wrap(
                runSpacing: CCSize.medium,
                spacing: CCSize.medium,
                children: [
                  ...relations // TODO: do not show currentUser
                          ?.map(
                            (relationship) => FriendPreview(
                              friendId: (relationship.users ?? [])
                                  .where((id) => id != friend.id)
                                  .first,
                            ),
                          )
                          .toList() ??
                      [],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
