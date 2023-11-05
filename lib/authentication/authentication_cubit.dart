import 'dart:async';

import 'package:crea_chess/authentication/authentication_crud.dart';
import 'package:crea_chess/authentication/authentication_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationModel> {
  AuthenticationCubit() : super(AuthenticationModel()) {
    setStreamSubscriptionAuthentication();
  }

  Future<void> signoutRequested() async {
    await AuthenticationCRUD.signOut();
  }

  void authenticationChanged(AuthenticationModel authentication) {
    emit(authentication);
  }

  void setStreamSubscriptionAuthentication() {
    cancelStreamSubscriptionAuthentication();
    streamSubscriptionAuthentication = AuthenticationCRUD.stream().listen(
      authenticationChanged,
    );
  }

  Future<void> cancelStreamSubscriptionAuthentication() async {
    if (streamSubscriptionAuthentication != null) {
      await streamSubscriptionAuthentication!.cancel();
    }
  }

  StreamSubscription<AuthenticationModel>? streamSubscriptionAuthentication;

  @override
  Future<void> close() {
    cancelStreamSubscriptionAuthentication();
    return super.close();
  }
}
