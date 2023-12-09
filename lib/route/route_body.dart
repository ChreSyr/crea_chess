import 'package:crea_chess/package/atomic_design/dialog/relationship/block_user_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/simple_badge.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/profile/profile/profile_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteBody extends StatelessWidget {
  const RouteBody({this.padded = true, this.centered = true, super.key});

  final bool padded;
  final bool centered;

  String getTitle(AppLocalizations l10n);

  List<Widget>? getActions(BuildContext context) => null;
}

abstract class MainRouteBody extends RouteBody {
  const MainRouteBody({
    required this.id,
    required this.icon,
    super.padded,
    super.centered,
    super.key,
  });

  final String id;
  final IconData icon;

  @override
  List<Widget> getActions(BuildContext context) {
    return [
      Row(
        children: [
          BlocBuilder<UserCubit, UserModel?>(
            builder: (context, user) {
              if (user == null || user.id == null) return Container();
              return StreamBuilder<Iterable<RelationshipModel>>(
                stream: relationshipCRUD.requestsAbout(user.id!),
                builder: (context, snapshot) {
                  final requests = snapshot.data ?? [];
                  final requestsTo =
                      requests.where((e) => !e.isRequestedBy(user.id!));
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
                      if (requestsTo.isEmpty) {
                        return iconButton;
                      } else {
                        // TODO: notif in nav bar or accessible everywhere
                        return SimpleIconButtonBadge(
                          child: iconButton,
                        );
                      }
                    },
                    menuChildren: requestsTo.isEmpty
                        ? [
                            MenuItemButton(
                              leadingIcon: const Icon(Icons.done_all),
                              onPressed: () {},
                              child: const Text('Aucune notification'),
                            ),
                          ]
                        : requestsTo
                            .map(
                              (e) => MenuItemButton(
                                leadingIcon: const Icon(Icons.mail),
                                onPressed: () {
                                  final requester = e.requester;
                                  return answerFriendRequest(
                                    context,
                                    requester,
                                  );
                                },
                                child: Text(context.l10n.friendRequest),
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
                context.push('/sso');
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
                              context.push('/sso');
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

// TODO: dialogs folder in atomic design

void answerFriendRequest(BuildContext pageContext, String? fromUserId) {
  if (fromUserId == null) return;
  final currentUserId = pageContext.read<UserCubit>().state?.id;
  if (currentUserId == null) return; // should never happen
  showDialog<AlertDialog>(
    context: pageContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // TODO: l10n
        title: const Text('Nouvelle demande en ami !'),
        content: FutureBuilder<UserModel?>(
          future: userCRUD.read(documentId: fromUserId),
          builder: (context, snapshot) {
            final friend = snapshot.data;
            return ListTile(
              leading: UserProfilePhoto(friend?.photo),
              title: Text(friend?.username ?? ''),
            );
          },
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            onPressed: () {
              relationshipCRUD.delete(
                documentId: relationshipCRUD.getId(fromUserId, currentUserId),
              );
              dialogContext.pop();
              showBlockUserDialog(pageContext, fromUserId);
            },
            label: const Text('Refuser'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              dialogContext.pop();
              relationshipCRUD.makeFriends(fromUserId, currentUserId);
              snackBarNotify(pageContext, 'Demande en ami acceptée !');
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
          // TODO : toutes les parties jouées et messages envoyés
          // seront définitivement supprimées
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
