import 'package:crea_chess/package/authentication/authentication_crud.dart';
import 'package:crea_chess/package/form/input/input_boolean.dart';
import 'package:crea_chess/package/form/input/input_email.dart';
import 'package:crea_chess/package/form/input/input_password.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:crea_chess/package/form/signup/signup_form.dart';
import 'package:crea_chess/package/form/signup/signup_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupForm> {
  SignupCubit()
      : super(
          SignupForm(
            email: const InputEmail.pure(isRequired: true),
            username: const InputString.pure(), // Todo?
            password: const InputPassword.pure(isRequired: true),
            confirmPassword: const InputPassword.pure(isRequired: true),
            acceptConditions: const InputBoolean.pure(isRequired: true),
            status: SignupStatus.inProgress,
          ),
        );

  void clearFailure() {
    emit(state.copyWith(status: SignupStatus.inProgress));
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: state.email.copyWith(string: value.toLowerCase()),
      ),
    );
  }

  void usernameChanged(String value) {
    emit(
      state.copyWith(
        username: state.username.copyWith(string: value.toLowerCase()),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: state.password.copyWith(string: value)));
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: state.confirmPassword.copyWith(string: value),
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void acceptedConditionsChanged(bool? boolean) {
    emit(
      state.copyWith(
        acceptConditions: state.acceptConditions.copyWith(boolean: boolean),
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isValid) {
      return emit(state.copyWith(status: SignupStatus.editError));
    }

    if (state.password.value != state.confirmPassword.value) {
      return emit(state.copyWith(status: SignupStatus.passwordsDontMatch));
    }

    emit(state.copyWith(status: SignupStatus.inProgress));

    try {
      if (await AuthenticationCRUD.userExist(state.email.value)) {
        return emit(state.copyWith(status: SignupStatus.mailTaken));
      }
    } on FirebaseAuthException {
      //
    }

    try {
      await AuthenticationCRUD.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      // reset cubit when success
      emit(
        state.copyWith(
          email: state.email.copyWith(string: ''),
          password: state.password.copyWith(string: ''),
          status: SignupStatus.inProgress,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SignupStatus.unexpectedError));
    }
  }
}
