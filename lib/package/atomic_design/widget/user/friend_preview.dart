import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FriendPreview extends StatelessWidget {
  const FriendPreview({required this.friendId, super.key});

  final String friendId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: userCRUD.stream(documentId: friendId),
      builder: (context, snapshot) {
        final friend = snapshot.data;
        if (friend == null) return const CircularProgressIndicator();
        return InkWell(
          onTap: () => context.push('/profile/friend_profile/$friendId'),
          child: UserProfilePhoto(
            friend.photo,
            radius: CCSize.xlarge,
          ),
        );
      },
    );
  }
}
