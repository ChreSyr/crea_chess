import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/decoration.dart';
import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/card_button.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/form/signin/signin_cubit.dart';
import 'package:crea_chess/package/form/signin/signin_form.dart';
import 'package:crea_chess/package/form/signin/signin_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav/nav_sub_screen.dart';
import 'package:crea_chess/route/nav/profile/profile_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends NavSubScreen {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(),
      child: const _SigninScreen(),
    );
  }
}

class _SigninScreen extends StatelessWidget {
  const _SigninScreen();

  @override
  Widget build(BuildContext context) {
    final signinCubit = context.read<SigninCubit>();

    return BlocConsumer<SigninCubit, SigninForm>(
      listener: (context, form) {
        switch (form.status) {
          case SigninStatus.userNotFound: // Todo: proposer de créer un compte
          case SigninStatus.wrongPassword:
            snackBarError(
              context,
              context.l10n.formError(form.status.name),
            );
            signinCubit.clearFailure();
          case SigninStatus.resetPasswordSuccess:
            snackBarNotify(
              context,
              'Check your mail box !',
            );
          case _:
            break;
        }
      },
      builder: (context, form) {
        return ListView(
          shrinkWrap: true,
          children: [
            CCGap.large,

            // Welcome back !
            const Text(
              '😄',
              style: TextStyle(fontSize: CCWidgetSize.xxsmall),
              textAlign: TextAlign.center,
            ),
            Text(
              context.l10n.welcomeBack,
              textAlign: TextAlign.center,
            ),

            CCGap.xlarge,

            // mail field
            TextFormField(
              decoration: CCInputDecoration(
                context: context,
                hintText: context.l10n.email,
                errorText: form.errorMessage(form.email, context.l10n),
              ),
              initialValue: form.email.value,
              keyboardType: TextInputType.emailAddress,
              onChanged: signinCubit.emailChanged,
              style: TextStyle(color: CCColor.fieldTextColor),
            ),

            CCGap.small,

            // password textfield
            TextFormField(
              obscureText: true,
              decoration: CCInputDecoration(
                context: context,
                hintText: context.l10n.password,
                errorText: form.errorMessage(form.password, context.l10n),
              ),
              initialValue: form.password.value,
              keyboardType: TextInputType.visiblePassword,
              onChanged: signinCubit.passwordChanged,
              style: TextStyle(color: CCColor.fieldTextColor),
            ),

            CCGap.small,

            // forgot password?
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: signinCubit.submitResetPassword,
                child: Text(context.l10n.passwordForgot),
              ),
            ),

            CCGap.medium,

            // sign in button
            FilledButton(
              onPressed: signinCubit.submit,
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
                  onTap: AuthenticationCRUD.signInWithGoogle,
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
                ),
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
                  onPressed: context.read<ProfileNavCubit>().goSignup,
                  child: Text(context.l10n.registerNow),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
