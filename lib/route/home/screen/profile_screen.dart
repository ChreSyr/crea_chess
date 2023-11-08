import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/screen/signin_screen.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/authentication/authentication_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        return CCPadding.horizontalLarge(
          child: Center(
            child:
                auth.isAbsent ? const SigninScreen() : const _ProfileScreen(),
          ),
        );
      },
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: CCSize.xxlarge,
              backgroundImage: NetworkImage(auth.photo ?? ''),
            ),
            CCGap.small,
            Text(auth.email ?? ''),
            CCGap.large,
            ElevatedButton.icon(
              onPressed: context.read<AuthenticationCubit>().signoutRequested,
              icon: const Icon(Icons.logout),
              label: Text(context.l10n.disconnect),
            ),
          ],
        );
      },
    );
  }
}
