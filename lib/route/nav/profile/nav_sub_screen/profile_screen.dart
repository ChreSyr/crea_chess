import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/nav_sub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends NavSubScreen {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: CCSize.xxlarge,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  auth.photo == null ? null : NetworkImage(auth.photo!),
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
