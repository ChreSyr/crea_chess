import 'package:crea_chess/package/atomic_design/color.dart';
import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/package/atomic_design/field/password_form_field.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/form/signup/signup_cubit.dart';
import 'package:crea_chess/package/form/signup/signup_form.dart';
import 'package:crea_chess/package/form/signup/signup_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupBody extends RouteBody {
  const SignupBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.registration;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocListener<AuthenticationCubit, AuthenticationModel>(
        listener: (context, auth) {
          if (!auth.isAbsent) context.pop();
        },
        child: const _SignupBody(),
      ),
    );
  }
}

class _SignupBody extends StatelessWidget {
  const _SignupBody();

  @override
  Widget build(BuildContext context) {
    final signupCubit = context.read<SignupCubit>();

    return BlocConsumer<SignupCubit, SignupForm>(
      listener: (context, form) {
        switch (form.status) {
          case SignupStatus.unexpectedError:
          case SignupStatus.mailTaken: // Todo : l10n
            snackBarError(
              context,
              context.l10n.formError(form.status.name),
            );
            signupCubit.clearFailure();
          case SignupStatus.signupSuccess:
            context.push('/profile/email_verification');
          case _:
            break;
        }
      },
      builder: (context, form) {
        return SizedBox(
          width: CCWidgetSize.large3,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (form.status == SignupStatus.waiting)
                const LinearProgressIndicator(),
              // Welcome among us !
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
                  hintText: context.l10n.email,
                  errorText: form.errorMessage(form.email, context.l10n),
                ),
                initialValue: form.email.value,
                keyboardType: TextInputType.emailAddress,
                onChanged: signupCubit.emailChanged,
              ),

              CCGap.small,

              // password textfield
              PasswordFromField(
                hintText: context.l10n.password,
                errorText: form.errorMessage(form.password, context.l10n),
                initialValue: form.password.value,
                onChanged: signupCubit.passwordChanged,
              ),

              CCGap.small,

              // confirm password textfield
              PasswordFromField(
                hintText: context.l10n.passwordConfirmation,
                errorText:
                    form.errorMessage(form.confirmPassword, context.l10n),
                initialValue: form.confirmPassword.value,
                onChanged: signupCubit.confirmPasswordChanged,
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
                onPressed: signupCubit.submit, // TODO : confirm email
                child: Text(context.l10n.signup),
              ),
            ],
          ),
        );
      },
    );
  }
}
