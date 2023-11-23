import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/nav_notif_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
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
  const ProfileBody({super.key});

  @override
  Icon getIcon() {
    return const Icon(Icons.person);
  }

  @override
  String getId() {
    return 'profile';
  }

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.profile;
  }

  @override
  List<Widget> getActions(BuildContext context) {
    return [
      BlocBuilder<AuthenticationCubit, AuthenticationModel>(
        builder: (context, auth) {
          final isLoggedIn = !auth.isAbsent;
          void signout() => context
            ..read<AuthenticationCubit>().signoutRequested()
            ..go('/profile/sign_methods');
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
                          confirmDeleteAccount(context, auth);
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

  Future<AlertDialog?> confirmDeleteAccount(
    BuildContext context,
    AuthenticationModel auth,
  ) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            context.l10n.deleteAccountExplanation(auth.email ?? 'ERROR'),
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
                  authenticationCRUD.deleteUserAccount(userId: auth.id);
                  snackBarNotify(context, context.l10n.deletedAccount);
                  context
                    ..read<AuthenticationCubit>().signoutRequested()
                    ..pop();
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
    return BlocConsumer<AuthenticationCubit, AuthenticationModel>(
      listener: (context, auth) {
        if (!auth.isAbsent && (auth.emailVerified != true)) {
          context.read<NavNotifCubit>().add(getId(), notifEmailNotVerified);
        } else {
          context.read<NavNotifCubit>().remove(getId(), notifEmailNotVerified);
        }
        if (!auth.isAbsent && (auth.name ?? '').isEmpty) {
          context.read<NavNotifCubit>().add(getId(), notifNameEmpty);
        } else {
          context.read<NavNotifCubit>().remove(getId(), notifNameEmpty);
        }
      },
      builder: (context, auth) {
        if (auth.isAbsent) {
          return FilledButton.icon(
            onPressed: () => context.go('/profile/sign_methods'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        }
        return UserDetails(
          user: auth,
        );
      },
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({required this.user, super.key});

  final AuthenticationModel user;

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
                    backgroundColor:
                        user.photo == null ? Colors.grey : Colors.transparent,
                    backgroundImage:
                        user.photo == null ? null : NetworkImage(user.photo!),
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
                    onPressed: () {}, // TODO
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(user.name ?? ''),
          trailing: (user.name ?? '').isEmpty
              ? const Icon(Icons.priority_high, color: Colors.red)
              : const Icon(Icons.edit),
          onTap: () => context.push('/profile/modify_name'),
        ),
        CCGap.small,
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(user.email ?? ''),
          // email verification
          trailing: (user.emailVerified ?? false)
              ? null
              : const Icon(Icons.priority_high, color: Colors.red),
          // email verification
          onTap: (user.emailVerified ?? false)
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
                            child: Text(context.l10n.verifyEmailSendLink),
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
