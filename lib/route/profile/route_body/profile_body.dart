import 'dart:math';

import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/modal/modal.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/firebase/authentication/user_crud.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// TODO: welcome and connect page when it is the first opening of the app

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
  const ProfileBody({super.key}) : super(id: 'profile');

  @override
  Icon getIcon() {
    // TODO : MainRouteBody.icon
    return const Icon(Icons.person);
  }

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.profile;
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [
      BlocBuilder<UserCubit, User?>(
        builder: (context, user) {
          final isLoggedIn = user != null;
          void signout() {
            userCRUD.signOut();
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
                  userCRUD.deleteUserAccount(userId: user.uid);
                  snackBarNotify(context, context.l10n.deletedAccount);
                  // pop menu
                  context.pop();
                  // sigout
                  userCRUD.signOut();
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

  static const notifEmailNotVerified = 'email-not-verified';
  static const notifNameEmpty = 'name-empty';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, User?>(
      listener: (context, user) {
        if (user == null) {
          context.read<NavNotifCubit>().remove(id, notifNameEmpty);
          context.read<NavNotifCubit>().remove(id, notifEmailNotVerified);
        } else {
          if ((user.photoURL ?? '').isEmpty) {
            // TODO: remove, notif instead
            userCRUD.updateUser(
              photoURL:
                  'avatar-${avatarNames[Random().nextInt(avatarNames.length)]}',
            );
          }
          if ((user.displayName ?? '').isEmpty) {
            context.read<NavNotifCubit>().add(id, notifNameEmpty);
          } else {
            context.read<NavNotifCubit>().remove(id, notifNameEmpty);
          }
          if (user.emailVerifiedOrProvided != true) {
            context.read<NavNotifCubit>().add(id, notifEmailNotVerified);
          } else {
            context.read<NavNotifCubit>().remove(id, notifEmailNotVerified);
          }
        }
      },
      builder: (context, user) {
        if (user == null) {
          return FilledButton.icon(
            onPressed: () => context.go('/profile/sign_methods'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        }
        return UserDetails(user: user);
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

class UserDetails extends StatelessWidget {
  const UserDetails({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: SizedBox(
            height: CCSize.xxxlarge * 2,
            width: CCSize.xxxlarge * 3,
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: CCSize.xxxlarge,
                    backgroundColor: user.photoURL == null
                        ? Colors.grey // TODO: notif
                        : Colors.transparent,
                    backgroundImage: getPhotoAsset(user.photoURL),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: CCColor.onBackground(context),
                    ),
                    onPressed: () => Modal.show(
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
                                    userCRUD.updateUser(
                                      photoURL: 'avatar-$e',
                                    );
                                    context.pop();
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                      'assets/avatar/$e.jpg',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(user.displayName ?? ''),
          trailing: (user.displayName ?? '').isEmpty
              ? const Icon(Icons.priority_high, color: Colors.red)
              : const Icon(Icons.edit),
          onTap: () => context.push('/profile/modify_name'),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(user.email ?? ''),
          // email verification
          trailing: user.emailVerifiedOrProvided
              ? null
              : const Icon(Icons.priority_high, color: Colors.red),
          // email verification
          onTap: user.emailVerifiedOrProvided
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
    );
  }
}
