import 'dart:io';

import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/firebase/storage/extension.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
import 'package:crea_chess/route/profile/profile/profile_photo.dart';
import 'package:crea_chess/route/profile/search_friend/search_friend_body.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// TODO: web can't see images from firebase storage
// TODO: welcome and connect page when it is the first opening of the app
// TODO: App Check

enum ProfileMenuChoices {
  signin(whenLoggedOut: true),
  signout(whenLoggedOut: false),
  deleteAccount(whenLoggedOut: false);

  const ProfileMenuChoices({required this.whenLoggedOut});

  final bool whenLoggedOut;

  String getLocalization(AppLocalizations l10n) {
    switch (this) {
      case ProfileMenuChoices.signin:
        return l10n.signin;
      case ProfileMenuChoices.signout:
        return l10n.signout;
      case ProfileMenuChoices.deleteAccount:
        return l10n.deleteAccount;
    }
  }

  IconData getIcon() {
    switch (this) {
      case ProfileMenuChoices.signin:
        return Icons.login;
      case ProfileMenuChoices.signout:
        return Icons.logout;
      case ProfileMenuChoices.deleteAccount:
        return Icons.delete_forever;
    }
  }
}

class ProfileBody extends MainRouteBody {
  const ProfileBody({super.key}) : super(id: 'profile', icon: Icons.person);

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.profile;
  }

  static const notifNotFullyAuthenticated = 'not-fully-authenticated';
  static const notifPhotoEmpty = 'photo-empty';
  static const notifNameEmpty = 'name-empty';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, User?>(
      listener: (context, auth) {
        if (auth == null) {
          context.read<NavNotifCubit>().remove(id, notifNotFullyAuthenticated);
        } else {
          if (auth.isFullyAuthenticated != true) {
            context.read<NavNotifCubit>().add(id, notifNotFullyAuthenticated);
          } else {
            context
                .read<NavNotifCubit>()
                .remove(id, notifNotFullyAuthenticated);
          }
        }
      },
      builder: (context, auth) {
        if (auth == null) {
          return FilledButton.icon(
            onPressed: () => context.go('/profile/sso'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        } else if (!auth.isFullyAuthenticated) {
          return NotFullyAuthenticated(auth: auth);
        }
        return BlocConsumer<UserCubit, UserModel?>(
          listener: (context, user) {
            if (user == null) {
              context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              context.read<NavNotifCubit>().remove(id, notifNameEmpty);
            } else {
              if ((user.photo ?? '').isEmpty) {
                context.read<NavNotifCubit>().add(id, notifPhotoEmpty);
              } else {
                context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              }
              if ((user.username ?? '').isEmpty || user.username == user.id) {
                context.read<NavNotifCubit>().add(id, notifNameEmpty);
              } else {
                context.read<NavNotifCubit>().remove(id, notifNameEmpty);
              }
            }
          },
          builder: (context, user) {
            // creating the user
            if (user == null) return const CircularProgressIndicator();

            return UserDetails(user: user);
          },
        );
      },
    );
  }
}

class NotFullyAuthenticated extends StatelessWidget {
  const NotFullyAuthenticated({
    required this.auth,
    super.key,
  });

  final User auth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CCWidgetSize.large3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Center(
              child: UserAvatar(
                auth.photoURL,
                radius: CCSize.xxxlarge,
                backgroundColor: auth.photoURL == null
                    ? Colors.red[100]
                    : null,
                
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: Text(auth.displayName ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(auth.email ?? ''),
            // email verification
            trailing: auth.isFullyAuthenticated
                ? null
                : const Icon(Icons.priority_high, color: Colors.red),
            // email verification
            onTap: auth.isFullyAuthenticated
                ? null
                : () => showDialog<AlertDialog>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            context.l10n.verifyEmailExplanation,
                          ),
                          actions: [
                            TextButton(
                              onPressed: context.pop,
                              child: Text(context.l10n.cancel),
                            ),
                            FilledButton(
                              child: Text(context.l10n.sendEmail),
                              onPressed: () {
                                context
                                  ..pop()
                                  ..push('/profile/sso/email_verification');
                              },
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CCWidgetSize.large3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.transparent),
            title: Center(
              child: UserAvatar(
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
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(context.read<AuthenticationCubit>().state?.email ?? ''),
          ),
          CCDivider.xthin,
          ListTile(
            leading: const Icon(Icons.groups),
            title: Text(context.l10n.friends),
            trailing: const Icon(Icons.person_add),
            onTap: () => searchFriend(context),
          ),
          BlocBuilder<UserCubit, UserModel?>(
            builder: (context, user) {
              if (user == null) return Container();
              return StreamBuilder<List<RelationshipModel>>(
                stream: relationshipCRUD.of(user.id),
                builder: (context, snapshot) {
                  final relations = snapshot.data;
                  return Wrap(
                    runSpacing: CCSize.medium,
                    spacing: CCSize.medium,
                    children: [
                      ...relations
                              ?.map(
                                (relationship) => FriendPreview(
                                  friendId: (relationship.users ?? [])
                                      .where((id) => id != user.id)
                                      .first,
                                ),
                              )
                              .toList() ??
                          [],
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
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

class ColoredCircleButton extends StatelessWidget {
  const ColoredCircleButton({required this.child, this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        child: child,
      ),
    );
  }
}

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
          onTap: () {},
          child: UserAvatar(
            friend.photo,
            radius: CCSize.xlarge,
          ),
        );
      },
    );
  }
}
