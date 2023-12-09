import 'package:crea_chess/package/atomic_design/dialog/relationship/unblock_user_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileRelationship extends StatelessWidget {
  const UserProfileRelationship({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserCubit>().state?.id;
    if (currentUserId == null) return Container(); // should never happen
    if (currentUserId == userId) return Container();

    return StreamBuilder<RelationshipModel?>(
      stream: relationshipCRUD.stream(
        documentId: relationshipCRUD.getId(currentUserId, userId),
      ),
      builder: (context, snapshot) {
        final relation = snapshot.data;
        switch (relation?.status) {
          case null:
          case RelationshipStatus.canceled:
            return FilledButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Demander en ami'), // TODO : l10n
              onPressed: () {
                relationshipCRUD.sendFriendRequest(
                  fromUserId: currentUserId,
                  toUserId: userId,
                );
                snackBarNotify(
                  context,
                  'Demande en ami envoyée',
                ); // TODO : l10n
              },
            );
          case RelationshipStatus.friends:
            return Container();
          case RelationshipStatus.requestedByFirst:
          case RelationshipStatus.requestedByLast:
            if (relation?.requester == userId) {
              return FilledButton.icon(
                onPressed: () => answerFriendRequest(context, userId),
                icon: const Icon(Icons.mail),
                label: const Text('Nouvelle demande en ami !'), // TODO : l10n
              );
            } else {
              return FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.send),
                label: const Text('Demande en ami envoyée'), // TODO : l10n
              );
            }
          case RelationshipStatus.blockedByFirst:
          case RelationshipStatus.blockedByLast:
            if (relation?.blocker == currentUserId) {
              return ElevatedButton.icon(
                onPressed: () => showUnblockUserDialog(context, userId),
                icon: const Icon(Icons.block),
                label: const Text(
                  'Vous avez bloqué cet utilisateur',
                ), // TODO : l10n
              );
            } else {
              return ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.block),
                label:
                    const Text('Cet utilisateur vous a bloqué'), // TODO : l10n
              );
            }
        }
      },
    );
  }
}
