import 'dart:io';

import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/dialog/relationship/block_user_dialog.dart';
import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/firebase/storage/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    required this.user,
    required this.editable,
    super.key,
  });

  final UserModel user;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const SizedBox(height: CCWidgetSize.xxxlarge),

            // banner
            Stack(
              children: [
                const SizedBox(
                  height: CCWidgetSize.large,
                  child: ListTile(
                    tileColor: Colors.grey,
                  ),
                ),
                if (editable)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: () {}, // TODO
                      icon: const Icon(Icons.edit),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => CCColor.background(context),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // photo
            Positioned(
              left: CCSize.small,
              bottom: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  UserProfilePhoto(
                    user.photo,
                    radius: CCWidgetSize.xxsmall,
                    backgroundColor:
                        user.photo == null ? Colors.red[100] : null,
                  ),
                  if (editable)
                    Positioned(
                      right: -CCSize.medium,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () => showPhotoModal(context),
                        icon: (user.photo ?? '').isEmpty
                            ? const Icon(Icons.priority_high, color: Colors.red)
                            : const Icon(Icons.edit),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => CCColor.background(context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // // profile name
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(user.username ?? ''),
          trailing: editable
              ? ((user.username ?? '').isEmpty || user.username == user.id)
                  ? const Icon(Icons.priority_high, color: Colors.red)
                  : const Icon(Icons.edit)
              : const Icon(Icons.more_horiz),
          onTap: editable
              ? () => context.push('/profile/modify_name')
              : () => showFriendActionsModal(context),
        ),
      ],
    );
  }

  void showFriendActionsModal(BuildContext context) {
    // TODO: l10n
    final currentUserId = context.read<UserCubit>().state?.id;
    if (currentUserId == null) return; // should never happen
    if (user.id == null) return; // should never happen

    // TODO: solve : if the user is not a friend, modal should only show 'block'

    return Modal.show(
      context: context,
      sections: [
        if (!kIsWeb)
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Bloquer'),
            onTap: () {
              context.pop();
              showBlockUserDialog(context, currentUserId, user.id!);
            },
          ),
        ListTile(
          leading: const Icon(Icons.person_remove),
          title: const Text('Retirer des amis'),
          onTap: () {
            // TODO: showCancelFriendshipDialog
            context.pop();
            relationshipCRUD.cancel(
              cancelerId: currentUserId,
              otherId: user.id!,
            );
            snackBarNotify(context, 'Retiré des amis');
          },
        ),
      ],
    );
  }

  void showPhotoModal(BuildContext context) {
    // TODO: l10n
    return Modal.show(
      context: context,
      sections: [
        if (!kIsWeb)
          ListTile(
            leading: const Icon(Icons.add_a_photo),
            title: const Text('Prendre une photo'),
            onTap: () {
              context.pop();
              uploadProfilePhoto(ImageSource.camera);
            },
          ),
        ListTile(
          leading: const Icon(Icons.drive_folder_upload),
          title: const Text('Importer une photo'),
          onTap: () {
            context.pop();
            uploadProfilePhoto(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Choisir un avatar'),
          onTap: () {
            context.pop();
            Modal.show(
              context: context,
              sections: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: CCSize.large,
                  mainAxisSpacing: CCSize.large,
                  children: avatarNames
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            userCRUD.userCubit.setPhoto(photo: 'avatar-$e');
                            context.pop();
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar/$e.jpg'),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> uploadProfilePhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    // TODO: fix for the web
    if (pickedFile == null) return;

    final photoRef = FirebaseStorage.instance.getUserPhotoRef(user.id!);
    await photoRef.putFile(File(pickedFile.path));
    await userCRUD.userCubit.setPhoto(photo: await photoRef.getDownloadURL());
  }
}
