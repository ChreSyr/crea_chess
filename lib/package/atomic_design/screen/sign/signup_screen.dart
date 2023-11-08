import 'package:crea_chess/package/atomic_design/screen/sign/sign_screen.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: context.read<SignNavCubit>().goToSignin,
      child: Text(context.l10n.alreadyHaveAccount),
    );
  }
}
