import 'package:crea_chess/package/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/authentication/authentication_model.dart';
import 'package:crea_chess/route/home/nav_screen/nav_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/profile/profile_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/profile/signin_screen.dart';
import 'package:crea_chess/route/home/nav_sub_screen/profile/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNavCubit extends NavCubit {
  ProfileNavCubit()
      : super(
          subscreens: [
            const ProfileScreen(),
            const SigninScreen(),
            const SignupScreen(),
          ],
          initialIndex: 1,
        );

  void goProfile() => emit(0);
  void goSignin() => emit(1);
  void goSignup() => emit(2);
}

class ProfileNavScreen extends NavScreen<ProfileNavCubit> {
  const ProfileNavScreen({super.key});

  @override
  ProfileNavCubit createCubit() => ProfileNavCubit();

  @override
  ProfileNavCubit getCubit(BuildContext context) {
    return context.read<ProfileNavCubit>();
  }

  @override
  Widget wrap(Widget subscreen) {
    return BlocBuilder<AuthenticationCubit, AuthenticationModel>(
      builder: (context, auth) {
        final navCubit = context.read<ProfileNavCubit>();
        auth.isAbsent ? navCubit.goSignin() : navCubit.goProfile();

        return subscreen;
      },
    );
  }
}
