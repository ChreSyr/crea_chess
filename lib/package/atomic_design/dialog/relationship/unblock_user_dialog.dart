import 'package:crea_chess/package/atomic_design/dialog/yes_no_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';

void showUnblockUserDialog(
  BuildContext pageContext,
  String blockerId,
  String toUnblockId,
) {
  showYesNoDialog(
    pageContext: pageContext,
    title: 'Débloquer cet utilisateur ?', // TODO: l10n
    content: FutureBuilder<UserModel?>(
      future: userCRUD.read(documentId: toUnblockId),
      builder: (context, snapshot) {
        final toBlock = snapshot.data;
        return ListTile(
          leading: UserProfilePhoto(toBlock?.photo),
          title: Text(toBlock?.username ?? ''),
        );
      },
    ),
    onYes: () {
      relationshipCRUD.unblock(
        blockerId: blockerId,
        toUnblockId: toUnblockId,
      );
      snackBarNotify(pageContext, 'Utilisateur débloqué'); // TODO: l10n
    },
  );
}
