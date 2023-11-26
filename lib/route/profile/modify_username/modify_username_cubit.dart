import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:crea_chess/route/profile/modify_username/modify_username_form.dart';
import 'package:crea_chess/route/profile/modify_username/modify_username_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyUsernameCubit extends Cubit<ModifyUsernameForm> {
  ModifyUsernameCubit(String initialName)
      : super(
          ModifyUsernameForm(
            name: InputString.dirty(
              string: initialName,
              isRequired: true,
            ),
            status: ModifyUsernameStatus.inProgress,
          ),
        );

  void clearFailure() {
    emit(state.copyWith(status: ModifyUsernameStatus.inProgress));
  }

  void setName(String name) {
    emit(state.copyWith(name: state.name.copyWith(string: name)));
  }

  Future<void> submit() async {
    if (state.isNotValid) {
      return emit(state.copyWith(status: ModifyUsernameStatus.editError));
    }

    emit(state.copyWith(status: ModifyUsernameStatus.waiting));

    try {
      userCRUD.userCubit.setUsername(username: state.name.value);
      emit(state.copyWith(status: ModifyUsernameStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ModifyUsernameStatus.unexpectedError));
    }
  }
}
