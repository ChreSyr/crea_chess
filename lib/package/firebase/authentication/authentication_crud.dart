import 'dart:async';

import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationCRUD {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleAuth = GoogleSignIn();

  static final _authenticationStreamController =
      StreamController<AuthenticationModel>();

  // Todo : separate stream & signin methods

  /// Get User (firebase object)
  static User? _getUser() {
    return _firebaseAuth.currentUser;
  }

  /// Stream User (firebase object) changes
  static Stream<User?> _streamUser() {
    return _firebaseAuth.userChanges();
  }

  /// Get AuthenticationModel
  static AuthenticationModel get() {
    return AuthenticationModel.fromUser(_getUser());
  }

  /// Send an email to reset the password
  static Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// SignIn with email and password
  static Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// SignIn with Google
  static Future<void> signInWithGoogle() async {
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
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();

    // Sign out to force the account chooser next time
    await _googleAuth.signOut();
  }

  /// SignUp with email and password
  static Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Stream AuthenticationModel
  static Stream<AuthenticationModel> stream() {
    _streamUser().listen((user) {
      _authenticationStreamController.add(AuthenticationModel.fromUser(user));
    });
    return _authenticationStreamController.stream;
  }

  /// True if mail in Authentication.
  static Future<bool> userExist(String email) async {
    return (await _firebaseAuth.fetchSignInMethodsForEmail(email)).isNotEmpty;
  }
}
