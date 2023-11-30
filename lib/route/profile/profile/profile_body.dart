
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

            return UserProfile(user: user, editable: true);
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
              child: UserProfilePhoto(
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
