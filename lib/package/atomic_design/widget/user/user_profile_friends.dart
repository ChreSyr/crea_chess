import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/user/friend_preview.Dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileFriends extends StatelessWidget {
  const UserProfileFriends({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<RelationshipModel>>(
      stream: relationshipCRUD.friendsOf(user.id),
      builder: (context, snapshot) {
        final relations = snapshot.data;
        final List<Widget> friendsPreviews = (relations ?? [])
            .map(
              (relationship) => FriendPreview(
                friendId: (relationship.users ?? [])
                    .where((id) => id != user.id)
                    .first,
              ),
            )
            .toList();
        if (context.read<UserCubit>().state?.id == user.id) {
          friendsPreviews.add(const FriendPreview(friendId: 'add'));
        }
        return Wrap(
          runSpacing: CCSize.medium,
          spacing: CCSize.medium,
          children: friendsPreviews,
        );
      },
    );
  }
}
