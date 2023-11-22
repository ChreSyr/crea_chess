import 'dart:async';

import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class _AuthenticationCRUD {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn(
    clientId:
        // ignore: lines_longer_than_80_chars
        '737365859201-spnihhusekc0prr23451hdjaj9a6dltc.apps.googleusercontent.com',
  );

  final _authenticationStreamController =
      StreamController<AuthenticationModel>();

  // Todo : separate stream & signin methods

  /// Get User (firebase object)
  User? _getUser() {
    return _firebaseAuth.currentUser;
  }

  /// Stream User (firebase object) changes
  Stream<User?> _streamUser() {
    return _firebaseAuth.userChanges();
  }

  void checkEmailVerified() {
    final user = _getUser();
    if (user == null) return;

    user.reload();
  }

  Future<void> deleteUserAccount({String? userId}) async {
    final user = _getUser();
    if (user == null) return;

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      print('------ ${e.code} ------');
      if (e.code == 'requires-recent-login') {
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

  /// Get AuthenticationModel
  AuthenticationModel get() {
    return AuthenticationModel.fromUser(_getUser());
  }

  Future<void> sendEmailVerification() async {
    final user = _getUser();
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

  /// Stream AuthenticationModel
  Stream<AuthenticationModel> stream() {
    _streamUser().listen((user) {
      _authenticationStreamController.add(AuthenticationModel.fromUser(user));
    });
    return _authenticationStreamController.stream;
  }
}

final authenticationCRUD = _AuthenticationCRUD();
