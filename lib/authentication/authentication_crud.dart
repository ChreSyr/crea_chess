import 'dart:async';

import 'package:crea_chess/authentication/authentication_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationCRUD {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final _authenticationStreamController =
      StreamController<AuthenticationModel>();

  /// Get AuthenticationModel
  static AuthenticationModel get() {
    return AuthenticationModel.fromUser(_getUser());
  }

  /// Stream AuthenticationModel
  static Stream<AuthenticationModel> stream() {
    _streamUser().listen((user) {
      _authenticationStreamController.add(AuthenticationModel.fromUser(user));
    });
    return _authenticationStreamController.stream;
  }

  /// Get User (firebase object)
  static User? _getUser() {
    return _firebaseAuth.currentUser;
  }

  /// Stream User (firebase object) changes
  static Stream<User?> _streamUser() {
    return _firebaseAuth.userChanges();
  }

  /// SignIn with Google
  static signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // Handle the case where the user canceled the sign-in
      return null;
    }

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// SingOut current User
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();

    // Sign out to force the account chooser next time
    await GoogleSignIn().signOut();
  }
}
