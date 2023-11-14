import 'package:crea_chess/package/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/authentication/authentication_model.dart';
import 'package:crea_chess/route/nav/nav_screen.dart';
import 'package:crea_chess/route/nav/profile/nav_sub_screen/profile_screen.dart';
import 'package:crea_chess/route/nav/profile/nav_sub_screen/signin_screen.dart';
import 'package:crea_chess/route/nav/profile/nav_sub_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNavCubit extends NavCubit {
  ProfileNavCubit()
      : super(
          subscreens: [
            const SigninScreen(),
            const SignupScreen(),
            const ProfileScreen(),
          ],
          initialIndex: 0,
        );

  void goSignin() => emit(0);
  void goSignup() => emit(1);
  void goProfile() => emit(2);
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
