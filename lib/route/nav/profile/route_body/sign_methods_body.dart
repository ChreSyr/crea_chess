import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/card_button.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignMethodsBody extends RouteBody {
  const SignMethodsBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.signin;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, User?>(
      listener: (context, user) {
        if (user != null) context.pop();
      },
      child: const _SignMethodsBody(),
    );
  }
}

class _SignMethodsBody extends StatelessWidget {
  const _SignMethodsBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CCWidgetSize.large3,
      child: ListView(
        shrinkWrap: true,
        children: [
          // sign in button
          FilledButton(
            onPressed: () => context.push('/profile/signin'),
            child: Text(context.l10n.signin),
          ),

          CCGap.small,

          // sign up button
          FilledButton(
            onPressed: () => context.push('/profile/signup'),
            child: Text(context.l10n.signup),
          ),

          CCGap.medium,

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
          Center(
            child: CardButton(
              onTap: authenticationCRUD.signInWithGoogle,
              child: CCPadding.allLarge(
                child: Image.asset(
                  'assets/icon/google_icon.png',
                  height: CCSize.xxlarge,
                ),
              ),
            ),
          ),

          CCGap.large,
        ],
      ),
    );
  }
}
