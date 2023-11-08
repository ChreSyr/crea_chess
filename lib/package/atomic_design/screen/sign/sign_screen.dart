import 'package:crea_chess/package/atomic_design/screen/sign/signin_screen.dart';
import 'package:crea_chess/package/atomic_design/screen/sign/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignNavCubit extends Cubit<int> {
  SignNavCubit() : super(0);

  void goToSignin() => emit(0);
  void goToSignup() => emit(1);
}

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignNavCubit(),
      child: BlocBuilder<SignNavCubit, int>(
        builder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: index == 0 ? const SigninScreen() : const SignupScreen(),
          );
        },
      ),
    );
  }
}
