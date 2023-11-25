import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleAuth = GoogleSignIn(
  clientId:
      // ignore: lines_longer_than_80_chars
      '737365859201-spnihhusekc0prr23451hdjaj9a6dltc.apps.googleusercontent.com',
);

class _UserCRUD {
  final userCubit = UserCubit._();

  /// Permanently delete account. Reauthentication possible.
  Future<void> deleteUserAccount({String? userId}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      print('------ ${e.code} ------'); // TODO : test
      if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
        final providerData = user.providerData.first;
        final googleAuthProvider = GoogleAuthProvider();

        if (googleAuthProvider.providerId == providerData.providerId) {
          await user.reauthenticateWithProvider(googleAuthProvider);
        }

        await user.delete();
      } else {
        rethrow;
      }
    }
  }

  /// Reload the user, to check if something changed.
  void reloadUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    user.reload();
  }

  /// Send an email to verify property
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    await user.sendEmailVerification();
  }

  /// Send an email to reset the password
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// SignIn with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// SignIn with Google
  Future<void> signInWithGoogle() async {
    // begin interactive sign in process
    final gUser = await _googleAuth.signIn();

    if (gUser == null) {
      // Handle the case where the user canceled the sign-in
      return;
    }

    // obtain auth details from request
    final gAuth = await gUser.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// SingOut current User
  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    // Sign out to force the account chooser next time
    await _googleAuth.signOut();
  }

  /// SignUp with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Update the user data
  Future<void> updateUser({String? displayName, String? photoURL}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    if (displayName != null) await user.updateDisplayName(displayName);
    if (photoURL != null) await user.updatePhotoURL(photoURL);
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit._() : super(_firebaseAuth.currentUser) {
    userStreamSubscription = _firebaseAuth.userChanges().listen(emit);
  }

  late StreamSubscription<User?> userStreamSubscription;

  @override
  Future<void> close() {
    userStreamSubscription.cancel();
    return super.close();
  }
}

final userCRUD = _UserCRUD();