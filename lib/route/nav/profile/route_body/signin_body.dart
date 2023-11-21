import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/package/atomic_design/field/password_form_field.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/form/signin/signin_cubit.dart';
import 'package:crea_chess/package/form/signin/signin_form.dart';
import 'package:crea_chess/package/form/signin/signin_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SigninBody extends RouteBody {
  const SigninBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.signin; // TODO
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationModel>(
      listener: (context, auth) {
        if (!auth.isAbsent) {
          context.pop();
        }
      },
      child: BlocProvider(
        create: (context) => SigninCubit(),
        child: const _SigninBody(),
      ),
    );
  }
}

class _SigninBody extends StatelessWidget {
  const _SigninBody();

  @override
  Widget build(BuildContext context) {
    final signinCubit = context.read<SigninCubit>();

    return BlocConsumer<SigninCubit, SigninForm>(
      listener: (context, form) {
        switch (form.status) {
          case SigninStatus.invalidCredentials:
          case SigninStatus.unexpectedError:
            snackBarError(
              context,
              context.l10n.formError(form.status.name),
            );
            signinCubit.clearFailure();
          case SigninStatus.resetPasswordSuccess:
            snackBarNotify(
              context,
              context.l10n.verifyMailbox,
            );
            signinCubit.clearFailure();
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
              if (form.status == SigninStatus.waiting)
                const LinearProgressIndicator(),
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
                  hintText: context.l10n.email,
                  errorText: form.errorMessage(form.email, context.l10n),
                ),
                initialValue: form.email.value,
                keyboardType: TextInputType.emailAddress,
                onChanged: signinCubit.emailChanged,
                onFieldSubmitted: (value) => signinCubit.submit(),
              ),

              CCGap.small,

              // password textfield
              PasswordFromField(
                hintText: context.l10n.password,
                errorText: form.errorMessage(form.password, context.l10n),
                initialValue: form.password.value,
                onChanged: signinCubit.passwordChanged,
                onFieldSubmitted: (value) => signinCubit.submit(),
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
            ],
          ),
        );
      },
    );
  }
}
