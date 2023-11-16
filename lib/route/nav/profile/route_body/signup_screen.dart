import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/decoration.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/form/signup/signup_cubit.dart';
import 'package:crea_chess/package/form/signup/signup_form.dart';
import 'package:crea_chess/package/form/signup/signup_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends RouteBody {
  const SignupScreen({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.signup;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: const _SignupScreen(),
    );
  }
}

class _SignupScreen extends StatelessWidget {
  const _SignupScreen();

  @override
  Widget build(BuildContext context) {
    final signupCubit = context.read<SignupCubit>();

    return BlocConsumer<SignupCubit, SignupForm>(
      listener: (context, form) {
        switch (form.status) {
          case SignupStatus.mailTaken: // Todo : l10n
            snackBarError(
              context,
              context.l10n.formError(form.status.name),
            );
            signupCubit.clearFailure();
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
              '🎉',
              style: TextStyle(fontSize: CCWidgetSize.xxsmall),
              textAlign: TextAlign.center,
            ),
            Text(
              context.l10n.welcomeAmongUs,
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
              onChanged: signupCubit.emailChanged,
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
              onChanged: signupCubit.passwordChanged,
              style: TextStyle(color: CCColor.fieldTextColor),
            ),

            CCGap.small,

            // confirm password textfield
            TextFormField(
              obscureText: true,
              decoration: CCInputDecoration(
                context: context,
                hintText: context.l10n.passwordConfirmation,
                errorText:
                    form.errorMessage(form.confirmPassword, context.l10n),
              ),
              initialValue: form.confirmPassword.value,
              keyboardType: TextInputType.visiblePassword,
              onChanged: signupCubit.confirmPasswordChanged,
              style: TextStyle(color: CCColor.fieldTextColor),
            ),

            CCGap.medium,

            // conditions
            Row(
              children: [
                Checkbox(
                  value: form.acceptConditions.value,
                  onChanged: signupCubit.acceptedConditionsChanged,
                ),
                Expanded(
                  child: Text(
                    context.l10n.iAcceptConditions,
                    maxLines: 3,
                    style: form.errorMessage(
                              form.acceptConditions,
                              context.l10n,
                            ) ==
                            null
                        ? null
                        : TextStyle(color: CCColor.error(context)),
                  ),
                ),
              ],
            ),

            CCGap.medium,

            // sign in button
            FilledButton(
              onPressed: signupCubit.submit,
              child: Text(context.l10n.signup),
            ),

            CCGap.large,

            // already have an account ?
            Center(
              child: TextButton(
                onPressed: () => context.go('profile/signin'),
                child: Text(context.l10n.alreadyHaveAccount),
              ),
            ),
          ],
        );
      },
    );
  }
}
