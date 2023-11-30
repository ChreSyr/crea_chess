import 'dart:io';

import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/firebase/storage/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.transparent),
          title: Center(
            child: UserProfilePhoto(
              user.photo,
              radius: CCSize.xxxlarge,
              backgroundColor: user.photo == null ? Colors.red[100] : null,
            ),
          ),
          trailing: (user.photo ?? '').isEmpty
              ? const Icon(Icons.priority_high, color: Colors.red)
              : const Icon(Icons.edit),
          onTap: () => showPhotoModal(context),
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(user.username ?? ''),
          trailing: (user.username ?? '').isEmpty || user.username == user.id
              ? const Icon(Icons.priority_high, color: Colors.red)
              : const Icon(Icons.edit),
          onTap: () => context.push('/profile/modify_name'),
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
