import 'package:crea_chess/authentication/authentication_cubit.dart';
import 'package:crea_chess/authentication/authentication_model.dart';
import 'package:crea_chess/package/atomic_design/decoration.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/card_button.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  static signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        return CCPadding.horizontalLarge(
          child: Center(
            child: auth.isAbsent ? _SigninScreen() : const _ProfileScreen(),
          ),
        );
      },
    );
  }
}

class _SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        CCGap.large,

        // Welcome back !
        const Text(
          '😄',
          style: TextStyle(fontSize: CCSize.xxxlarge),
          textAlign: TextAlign.center,
        ),
        Text(
          context.l10n.welcomeBack,
          textAlign: TextAlign.center,
        ),

        CCGap.xlarge,

        // username textfield
        TextField(
          decoration: CCInputDecoration(
            context: context,
            hintText: context.l10n.usernameOrMail,
          ),
        ),

        CCGap.small,

        // password textfield
        TextField(
          obscureText: true,
          decoration: CCInputDecoration(
            context: context,
            hintText: context.l10n.password,
          ),
        ),

        CCGap.small,

        // forgot password?
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(context.l10n.passwordForgot),
          ),
        ),

        CCGap.medium,

        // sign in button
        FilledButton(
          onPressed: () {},
          child: Text(context.l10n.signin),
        ),

        CCGap.xlarge,

        // or continue with
        Row(
          children: [
            Expanded(child: CCDivider.xthin),
            CCGap.small,
            Text(context.l10n.orContinueWith),
            CCGap.small,
            Expanded(child: CCDivider.xthin),
          ],
        ),

        CCGap.large,

        // google + apple sign in buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardButton(
              onTap: AuthService.signInWithGoogle,
              child: CCPadding.allLarge(
                child: Image.asset(
                  'assets/icon/google_icon.png',
                  height: CCSize.xxlarge,
                ),
              ),
            ),
            CCGap.large,
            CardButton(
              child: CCPadding.allLarge(
                child: Image.asset(
                  'assets/icon/apple_icon.png',
                  height: CCSize.xxlarge,
                ),
              ),
            )
          ],
        ),

        CCGap.large,

        // not a member? register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.needAccount),
            CCGap.xsmall,
            TextButton(
              onPressed: () {},
              child: Text(context.l10n.registerNow),
            ),
          ],
        )
      ],
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
