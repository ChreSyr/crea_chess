import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/user/friend_preview.Dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_details.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_header.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/profile/search_friend/search_friend_body.dart';
import 'package:flutter/material.dart';

class UserProfileBody extends StatelessWidget {
  const UserProfileBody({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CCWidgetSize.large3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserProfileHeader(user: user),
          const UserProfileDetails(),
          CCDivider.xthin,
          ListTile(
            leading: const Icon(Icons.groups),
            title: Text(context.l10n.friends),
            trailing: const Icon(Icons.person_add),
            onTap: () => searchFriend(context),
          ),
          StreamBuilder<List<RelationshipModel>>(
            stream: relationshipCRUD.of(user.id),
            builder: (context, snapshot) {
              final relations = snapshot.data;
              return Wrap(
                runSpacing: CCSize.medium,
                spacing: CCSize.medium,
                children: [
                  ...relations
                          ?.map(
                            (relationship) => FriendPreview(
                              friendId: (relationship.users ?? [])
                                  .where((id) => id != user.id)
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
