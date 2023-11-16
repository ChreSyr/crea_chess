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

class ProfileScreen extends RouteBody {
  const ProfileScreen({super.key});

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
            onPressed: () => context.go('/profile/signin'),
            icon: const Icon(Icons.login),
            label: Text(context.l10n.signin),
          );
        }
        return UserDetails(
          user: UserModel(
            id: auth.id,
            name: auth.name,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: CCSize.xxlarge,
          backgroundColor:
              user.photoUrl == null ? Colors.grey : Colors.transparent,
          backgroundImage:
              user.photoUrl == null ? null : NetworkImage(user.photoUrl!),
        ),
        CCGap.small,
        Text(user.name ?? ''),
        CCGap.large,
        ElevatedButton.icon(
          onPressed: () {
            context.go('/profile/signin');
            context.read<AuthenticationCubit>().signoutRequested();
          },
          icon: const Icon(Icons.logout),
          label: Text(context.l10n.disconnect),
        ),
      ],
    );
  }
}
