import 'package:badges/badges.dart' as badges;
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_crud.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_model.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/profile/profile/profile_body.dart';
import 'package:crea_chess/route/profile/profile/profile_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteBody extends StatelessWidget {
  const RouteBody({super.key});

  String getTitle(AppLocalizations l10n);

  List<Widget>? getActions(BuildContext context) => null;
}

abstract class MainRouteBody extends RouteBody {
  const MainRouteBody({required this.id, required this.icon, super.key});

  final String id;
  final IconData icon;

  @override
  List<Widget> getActions(BuildContext context) {
    return [
      Row(
        children: [
          BlocBuilder<UserCubit, UserModel?>(
            builder: (context, user) {
              if (user == null) return Container();
              return StreamBuilder<Iterable<NotificationModel>>(
                stream: notificationCRUD.streamFiltered(
                  filter: (colection) =>
                      colection.where('to', isEqualTo: user.id),
                ),
                builder: (context, snapshot) {
                  final notifications = snapshot.data ?? [];
                  return MenuAnchor(
                    builder: (
                      BuildContext context,
                      MenuController controller,
                      Widget? _,
                    ) {
                      final iconButton = IconButton(
                        onPressed: () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                        icon: const Icon(Icons.notifications),
                      );
                      if (notifications.isEmpty) {
                        return iconButton;
                      } else {
                        // TODO: notif in nav bar or accessible everywhere
                        return badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 3, end: 3),
                          child: iconButton,
                        );
                      }
                    },
                    menuChildren: notifications.isEmpty
                        ? [
                            MenuItemButton(
                              leadingIcon: const Icon(Icons.done_all),
                              onPressed: () {},
                              child: const Text('Aucune notification'),
                            ),
                          ]
                        : notifications
                            .map(
                              (e) => MenuItemButton(
                                leadingIcon: const Icon(Icons.mail),
                                onPressed: () {
                                  switch (e.type) {
                                    case NotificationType.friendRequest:
                                      answerFriendRequest(context, e);
                                    case null:
                                      return;
                                  }
                                },
                                child: Text(
                                  context.l10n
                                      .notificationType(e.type?.name ?? ''),
                                ),
                              ),
                            )
                            .toList(),
                  );
                },
              );
            },
          ),
          BlocBuilder<AuthenticationCubit, User?>(
            builder: (context, auth) {
              final isLoggedOut = auth == null;
              void signout() {
                authenticationCRUD.signOut();
                context.go('/profile/sign_methods');
              }

              return MenuAnchor(
                builder: (
                  BuildContext context,
                  MenuController controller,
                  Widget? _,
                ) {
                  return IconButton(
                    onPressed: () => controller.isOpen
                        ? controller.close()
                        : controller.open(),
                    icon: const Icon(Icons.more_vert),
                  );
                },
                menuChildren: ProfileMenuChoices.values
                    .where((e) => isLoggedOut == e.whenLoggedOut)
                    .map(
                      (e) => MenuItemButton(
                        leadingIcon: Icon(e.getIcon()),
                        onPressed: () {
                          switch (e) {
                            case ProfileMenuChoices.signin:
                              context.push('/profile/sign_methods');
                            case ProfileMenuChoices.signout:
                              signout();
                            case ProfileMenuChoices.deleteAccount:
                              confirmDeleteAccount(context, auth!);
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
        ],
      ),
    ];
  }
}

void answerFriendRequest(BuildContext context, NotificationModel notif) {
  if (notif.from == null || notif.to == null) return;
  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      void deleteNotification() {
        notificationCRUD.delete(documentId: notif.id);
      }

      return AlertDialog(
        title: const Text('Nouvelle demande en ami !'),
        content: FutureBuilder<UserModel?>(
          future: userCRUD.read(documentId: notif.from!),
          builder: (context, snapshot) {
            final friend = snapshot.data;
            if (friend == null) {
              return const CircularProgressIndicator();
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: getPhotoAsset(friend.photo),
              ),
              title: Text(friend.username ?? ''),
            );
          },
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
              deleteNotification();
              snackBarNotify(context, 'Demande en ami refusée.');
            },
            label: const Text('Refuser'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.pop();
              deleteNotification();
              relationshipCRUD.makeFriends(notif.from!, notif.to!);
              snackBarNotify(context, 'Demande en ami acceptée !');
            },
            label: const Text('Accepter'),
          ),
        ],
      );
    },
  );
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
