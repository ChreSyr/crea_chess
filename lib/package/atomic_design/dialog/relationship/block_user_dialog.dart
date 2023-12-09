import 'package:crea_chess/package/atomic_design/dialog/yes_no_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';

void showBlockUserDialog(
  BuildContext pageContext,
  String blockerId,
  String toBlockId,
) {
  showYesNoDialog(
    pageContext: pageContext,
    title: 'Bloquer cet utilisateur ?', // TODO: l10n
    content: FutureBuilder<UserModel?>(
      future: userCRUD.read(documentId: toBlockId),
      builder: (context, snapshot) {
        final toBlock = snapshot.data;
        return ListTile(
          leading: UserProfilePhoto(toBlock?.photo),
          title: Text(toBlock?.username ?? ''),
        );
        // TODO : il ne pourra plus voir votre liste d'amis
      },
    ),
    onYes: () {
      relationshipCRUD.block(
        blockerId: blockerId,
        toBlockId: toBlockId,
      );
      snackBarNotify(pageContext, 'Utilisateur bloqué'); // TODO: l10n
    },
  );
}
