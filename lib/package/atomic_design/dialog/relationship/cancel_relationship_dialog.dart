import 'package:crea_chess/package/atomic_design/dialog/yes_no_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';

void showCancelRelationshipDialog(
  BuildContext pageContext,
  String cancelerId,
  String relatedUserId,
) {
  showYesNoDialog(
    pageContext: pageContext,
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
      snackBarNotify(pageContext, 'Retiré des amis'); // TODO: l10n
    },
  );
}
