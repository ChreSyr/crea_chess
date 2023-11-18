import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/form/input/input_email.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:crea_chess/package/form/signin/signin_form.dart';
import 'package:crea_chess/package/form/signin/signin_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninForm> {
  SigninCubit()
      : super(
          SigninForm(
            email: const InputEmail.pure(isRequired: true),
            password: const InputString.pure(isRequired: true),
            status: SigninStatus.inProgress,
          ),
        );

  void clearFailure() {
    emit(state.copyWith(status: SigninStatus.inProgress));
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: state.email.copyWith(string: value.toLowerCase()),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: state.password.copyWith(string: value)));
  }

  Future<void> submit() async {
    if (!state.isValid) {
      return emit(state.copyWith(status: SigninStatus.editError));
    }

    emit(state.copyWith(status: SigninStatus.waiting));

    // TODO : can only signin if signin method is mail / password

    try {
      await authenticationCRUD.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      // reset cubit when success
      emit(
        state.copyWith(
          email: state.email.copyWith(string: ''),
          password: state.password.copyWith(string: ''),
          status: SigninStatus.inProgress,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-login-credentials') {
        emit(state.copyWith(status: SigninStatus.invalidCredentials));
      } else {
        emit(state.copyWith(status: SigninStatus.unexpectedError));
      }
    } catch (_) {
      emit(state.copyWith(status: SigninStatus.unexpectedError));
    }
  }

  Future<void> submitResetPassword() async {
    if (!state.email.isValid) {
      return emit(
        state.copyWith(status: SigninStatus.invalidMailForResetPassword),
      );
    }

    emit(state.copyWith(status: SigninStatus.waiting));

    // TODO : error if email doesn't exist
    // TODO : can only reset password if signin method is mail / password

    try {
      await authenticationCRUD.sendPasswordResetEmail(
        email: state.email.value,
      );
      emit(state.copyWith(status: SigninStatus.resetPasswordSuccess));
    } catch (_) {
      // TODO : resetPasswordError
      emit(state.copyWith(status: SigninStatus.userNotFound));
    }
  }
}

// test@gmail.com
