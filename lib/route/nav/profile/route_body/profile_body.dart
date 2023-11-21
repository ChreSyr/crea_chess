import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileBody extends RouteBody {
  const ProfileBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.profile;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        if (auth.isAbsent) {
          return FilledButton.icon(
            onPressed: () => context.go('/profile/sign_methods'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        }
        return UserDetails(
          user: UserModel(
            id: auth.id,
            name: auth.name,
            email: auth.email,
            emailVerified: auth.emailVerified,
            photoUrl: auth.photo,
          ),
        );
      },
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthenticationCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: CCSize.xxxlarge,
          backgroundColor:
              user.photoUrl == null ? Colors.grey : Colors.transparent,
          backgroundImage:
              user.photoUrl == null ? null : NetworkImage(user.photoUrl!),
        ),
        CCGap.large,
        ListTile(
          leading: Icon(Icons.alternate_email),
          title: Text(user.name ?? 'non renseigné'),
        ),
        CCGap.small,
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(user.email ?? ''),
          // email verification
          trailing: (user.emailVerified ?? false)
              ? null
              : Icon(
                  Icons.priority_high,
                  color: CCColor.error(context),
                ),
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
        CCGap.large,
        ElevatedButton.icon(
          onPressed: () {
            context.go('/profile/sign_methods');
            authCubit.signoutRequested();
          },
          icon: const Icon(Icons.logout),
          label: Text(context.l10n.disconnect),
        ),
      ],
    );
  }
}
