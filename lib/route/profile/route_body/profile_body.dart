import 'dart:io';

import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
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
  signout(whenLoggedOut: false),
  deleteAccount(whenLoggedOut: false);

  const ProfileMenuChoices({required this.whenLoggedOut});

  final bool whenLoggedOut;

  String getLocalization(AppLocalizations l10n) {
    switch (this) {
      case ProfileMenuChoices.signout:
        return l10n.signout;
      case ProfileMenuChoices.deleteAccount:
        return l10n.deleteAccount;
    }
  }

  IconData getIcon() {
    switch (this) {
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

  @override
  List<Widget> getActions(BuildContext context) {
    return [
      BlocBuilder<AuthenticationCubit, User?>(
        builder: (context, user) {
          final isLoggedIn = user != null;
          void signout() {
            authenticationCRUD.signOut();
            context.go('/profile/sign_methods');
          }

          return MenuAnchor(
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IconButton(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.more_vert),
              );
            },
            menuChildren: ProfileMenuChoices.values
                .where((e) => isLoggedIn || e.whenLoggedOut)
                .map(
                  (e) => MenuItemButton(
                    leadingIcon: Icon(e.getIcon()),
                    onPressed: () {
                      switch (e) {
                        case ProfileMenuChoices.signout:
                          signout();
                        case ProfileMenuChoices.deleteAccount:
                          confirmDeleteAccount(context, user!);
                      }
                    },
                    style: switch (e) {
                      ProfileMenuChoices.deleteAccount => ButtonStyle(
                          iconColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red,
                          ),
                          foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red,
                          ),
                        ),
                      _ => null,
                    },
                    child: Text(e.getLocalization(context.l10n)),
                  ),
                )
                .toList(),
          );
        },
      ),
    ];
  }

  Future<AlertDialog?> confirmDeleteAccount(BuildContext context, User user) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            context.l10n.deleteAccountExplanation(user.email ?? 'ERROR'),
          ),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              child: Text(context.l10n.deleteAccount),
              onPressed: () {
                try {
                  authenticationCRUD.deleteUserAccount(userId: user.uid);
                  snackBarNotify(context, context.l10n.deletedAccount);
                  // pop menu
                  context.pop();
                  // sigout
                  authenticationCRUD.signOut();
                } catch (_) {
                  snackBarError(context, context.l10n.errorOccurred);
                }
              },
            ),
          ],
        );
      },
    );
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
            onPressed: () => context.go('/profile/sign_methods'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        } else if (!auth.isFullyAuthenticated) {
          return NotFullyAuthenticated(auth: auth);
        }
        return BlocConsumer<UserCubit, UserModel?>(
          listener: (context, user) {
            if (user == null) {
              // TODO : move to auth listener ?
              context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              context.read<NavNotifCubit>().remove(id, notifNameEmpty);
            } else {
              if ((user.photo ?? '').isEmpty) {
                context.read<NavNotifCubit>().add(id, notifPhotoEmpty);
              } else {
                context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              }
              if ((user.username ?? '').isEmpty) {
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

const avatarNames = [
  'antoine',
  'cassandra',
  'catherine',
  'charles',
  'claude',
  'gabrielle',
  'hugo',
  'ines',
  'lea',
  'leo',
  'lucas',
  'madeleine',
  'maeva',
  'manu',
  'mathis',
  'nathan',
  'nick',
  'orion',
  'ricardo',
  'victor',
  'yannick',
];

ImageProvider<Object>? getPhotoAsset(String? photo) {
  if (photo == null) {
    return null;
  } else if (photo.startsWith('avatar-')) {
    return AssetImage('assets/${photo.replaceAll('-', '/')}.jpg');
  } else {
    return NetworkImage(photo);
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
              child: CircleAvatar(
                radius: CCSize.xxxlarge,
                backgroundColor: auth.photoURL == null
                    ? Colors.red[100]
                    : Colors.transparent,
                backgroundImage: getPhotoAsset(auth.photoURL),
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
                                  ..push('/profile/email_verification');
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
              child: CircleAvatar(
                radius: CCSize.xxxlarge,
                backgroundColor:
                    user.photo == null ? Colors.red[100] : Colors.transparent,
                backgroundImage: getPhotoAsset(user.photo),
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
            trailing: (user.username ?? '').isEmpty
                ? const Icon(Icons.priority_high, color: Colors.red)
                : const Icon(Icons.edit),
            onTap: () => context.push('/profile/modify_name'),
          ),
          CCDivider.xthin,
          const ListTile(
            leading: Icon(Icons.groups),
            title: Text('Friends'), // TODO: l10n
            // email verification
          ),
          BlocBuilder<UserCubit, UserModel?>(
            builder: (context, details) {
              return Wrap(
                children: [
                  ...details?.friends
                          ?.map((friendId) => FriendPreview(friendId: friendId))
                          .toList() ??
                      [],
                  ColoredCircleButton(
                    onTap: () => context.push('/profile/search_friend'),
                    child: const Icon(Icons.person_add),
                  ),
                ],
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

  // TODO: delete photo when deleting user
  Future<void> uploadProfilePhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    // TODO: fix for the web
    // TODO: compress image before storing
    print('picked $pickedFile');
    if (pickedFile == null) return;

    print('File name : ${pickedFile.name}');
    print('File path : ${pickedFile.path}');

    try {
      final photoRef = FirebaseStorage.instance
          .ref()
          .child('image')
          .child('userPhoto')
          .child(user.id!);
      await photoRef.putFile(File(pickedFile.path));
      await userCRUD.userCubit.setPhoto(photo: await photoRef.getDownloadURL());
    } catch (e) {
      // snackBarError(context, context.l10n.errorOccurred);
      print('ERROR OCCURED');
      rethrow;
    }
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
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          const CircleAvatar(),
          Text(
            friendId,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
