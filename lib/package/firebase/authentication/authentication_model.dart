import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_model.freezed.dart';

@freezed
class AuthenticationModel with _$AuthenticationModel {
  factory AuthenticationModel({
    String? id,
    DateTime? createdAt,
    DateTime? signInAt,
    String? name,
    bool? isAnonymous,
    String? email,
    bool? emailVerified,
    String? phone,
    String? photo,
  }) = _AuthenticationModel;

  factory AuthenticationModel.fromUser(User? user) {
    if (user == null) {
      return AuthenticationModel();
    }
    return AuthenticationModel(
      id: user.uid,
      createdAt: user.metadata.creationTime,
      signInAt: user.metadata.lastSignInTime,
      name: user.displayName,
      isAnonymous:
          (user.email ?? '').isEmpty && (user.phoneNumber ?? '').isEmpty,
      email: user.email,
      emailVerified: user.emailVerified,
      phone: user.phoneNumber,
      photo: user.photoURL,
    );
  }
}

extension AuthenticationModelExt on AuthenticationModel {
  bool get isAbsent => (id ?? '').isEmpty || emailVerified != true;
}
