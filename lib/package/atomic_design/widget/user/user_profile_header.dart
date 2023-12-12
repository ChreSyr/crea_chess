import 'dart:io';

import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/dialog/relationship/block_user.dart';
import 'package:crea_chess/package/atomic_design/dialog/relationship/cancel_relationship.dart';
import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/firebase/storage/extension.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserCubit>().state?.id;
    if (currentUserId == null) return Container(); // should never happen
    if (user.id == null) return Container(); // should never happen
    final userId = user.id!;

    final editable = currentUserId == userId;

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

        // // user name
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(user.username ?? ''),
          trailing: editable
              ? ((user.username ?? '').isEmpty || user.username == user.id)
                  ? const Icon(Icons.priority_high, color: Colors.red)
                  : const Icon(Icons.edit)
              : const Icon(Icons.more_horiz),
          onTap: editable
              ? () => context.push('/user/modify_name')
              : () => showUserActionsModal(context),
        ),
      ],
    );
  }

  void showUserActionsModal(BuildContext context) {
    final currentUserId = context.read<UserCubit>().state?.id;
    if (currentUserId == null) return; // should never happen
    if (user.id == null) return; // should never happen
    final userId = user.id!;

    return Modal.show(
      context: context,
      sections: [
        ListTile(
          leading: const Icon(Icons.block),
          title: Text(context.l10n.block),
          onTap: () {
            context.pop();
            showBlockUserDialog(context, userId);
          },
        ),
        StreamBuilder<RelationshipModel?>(
          stream: relationshipCRUD.stream(
            documentId: relationshipCRUD.getId(currentUserId, userId),
          ),
          builder: (modalContext, snapshot) {
            final relationship = snapshot.data;
            if (relationship?.status == RelationshipStatus.friends) {
              return ListTile(
                leading: const Icon(Icons.person_remove),
                title: Text(context.l10n.friendRemove),
                onTap: () {
                  modalContext.pop();
                  showCancelRelationshipDialog(context, userId);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  void showPhotoModal(BuildContext context) {
    return Modal.show(
      context: context,
      sections: [
        if (!kIsWeb)
          ListTile(
            leading: const Icon(Icons.add_a_photo),
            title: Text(context.l10n.pictureTake),
            onTap: () {
              context.pop();
              uploadProfilePhoto(ImageSource.camera);
            },
          ),
        ListTile(
          leading: const Icon(Icons.drive_folder_upload),
          title: Text(context.l10n.pictureImport),
          onTap: () {
            context.pop();
            uploadProfilePhoto(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(context.l10n.avatarChoose),
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
