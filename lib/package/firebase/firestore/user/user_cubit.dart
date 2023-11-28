import 'dart:async';

import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null) {
    authenticationStreamSubscription =
        FirebaseAuth.instance.userChanges().listen(_fromAuth);
  }

  void _fromAuth(User? auth) {
    if (auth == null || !auth.isFullyAuthenticated) {
      cancelUserStreamSubscription();
      emit(null);
      return;
    }

    cancelUserStreamSubscription();
    userStreamSubscription =
        userCRUD.stream(documentId: auth.uid).listen((user) {
      if (user == null) {
        // Create user
        userCRUD.create(
          documentId: auth.uid,
          data: UserModel(
            id: auth.uid,
            username: auth.displayName,
            photo: auth.photoURL,
          ),
        );
        return;
      }

      emit(user);
    });
  }

  void cancelUserStreamSubscription() {
    if (userStreamSubscription != null) {
      userStreamSubscription!.cancel();
      userStreamSubscription = null;
    }
  }

  StreamSubscription<UserModel?>? userStreamSubscription;
  late StreamSubscription<User?> authenticationStreamSubscription;

  @override
  Future<void> close() {
    cancelUserStreamSubscription();
    authenticationStreamSubscription.cancel();
    return super.close();
  }

  Future<void> setPhoto({required String photo}) async {
    if (state == null || state!.id == null) return;
    if (photo == state!.photo) return;

    await userCRUD.update(
      documentId: state!.id!,
      data: state!.copyWith(photo: photo),
    );
  }

  Future<void> setUsername({required String username}) async {
    if (state == null || state!.id == null) return;
    if (username == state!.username) return;

    await userCRUD.update(
      documentId: state!.id!,
      data: state!.copyWith(username: username),
    );
  }
}