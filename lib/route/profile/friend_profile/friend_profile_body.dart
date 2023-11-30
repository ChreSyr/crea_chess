import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/profile/profile/profile_body.dart';
import 'package:crea_chess/route/profile/profile/profile_photo.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';

final fakeFriend = UserModel(
    id: 'fenvjrnbfd',
    username: 'Faker',
    usernameLowercase: 'faker',
    photo: 'avatar-yannick');

class FriendProfileBody extends RouteBody {
  const FriendProfileBody({required this.friend, super.key});

  final UserModel friend;

  @override
  String getTitle(AppLocalizations l10n) {
    return "Nom de l'ami en question";
  }

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
              child: UserAvatar(
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
