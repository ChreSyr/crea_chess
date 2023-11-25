import 'dart:async';

import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<User?> {
  AuthenticationCubit() : super(null) {
    streamSubscriptionAuthentication = authenticationCRUD.stream().listen(emit);
  }

  late StreamSubscription<User?> streamSubscriptionAuthentication;

  @override
  Future<void> close() {
    streamSubscriptionAuthentication.cancel();
    return super.close();
  }
}
