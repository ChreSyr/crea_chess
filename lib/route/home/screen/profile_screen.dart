import 'package:crea_chess/authentication/authentication_cubit.dart';
import 'package:crea_chess/authentication/authentication_model.dart';
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
      builder: (context, state) {
        return Center(
          child: state.isAbsent
              ? ElevatedButton(
                  onPressed: AuthService.signInWithGoogle,
                  child: Image.asset(
                    'assets/icon/google_icon.png',
                    height: 100,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(state.photo ?? ''),
                    ),
                    Text(state.email ?? ''),
                    ElevatedButton.icon(
                      onPressed:
                          context.read<AuthenticationCubit>().signoutRequested,
                      icon: const Icon(Icons.logout),
                      label: const Text('Se déconnecter'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
