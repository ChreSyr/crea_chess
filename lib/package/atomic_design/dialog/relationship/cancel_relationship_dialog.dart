import 'package:crea_chess/package/atomic_design/dialog/yes_no_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCancelRelationshipDialog(
  BuildContext context,
  String cancelerId,
  String relatedUserId,
) {
  showYesNoDialog(
    context: context,
    title: 'Retirer des amis ?', // TODO: l10n
    content: FutureBuilder<UserModel?>(
      future: userCRUD.read(documentId: relatedUserId),
      builder: (context, snapshot) {
        final toBlock = snapshot.data;
        return ListTile(
          leading: UserProfilePhoto(toBlock?.photo),
          title: Text(toBlock?.username ?? ''),
        );
      },
    ),
    onYes: () {
      relationshipCRUD.cancel(
        cancelerId: cancelerId,
        otherId: relatedUserId,
      );
      context.pop();
      snackBarNotify(context, 'Retiré des amis'); // TODO: l10n
    },
  );
}
