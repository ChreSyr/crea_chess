import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_form.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyNameCubit extends Cubit<ModifyNameForm> {
  ModifyNameCubit(String initialName)
      : super(
          ModifyNameForm(
            name: InputString.dirty(
              string: initialName,
              isRequired: true,
            ),
            status: ModifyNameStatus.inProgress,
          ),
        );

  void clearFailure() {
    emit(state.copyWith(status: ModifyNameStatus.inProgress));
  }

  void setName(String name) {
    emit(state.copyWith(name: state.name.copyWith(string: name)));
  }

  Future<void> submit() async {
    if (state.isNotValid) {
      return emit(state.copyWith(status: ModifyNameStatus.editError));
    }

    emit(state.copyWith(status: ModifyNameStatus.waiting));

    try {
      await authenticationCRUD.updateUser(name: state.name.value);
      emit(state.copyWith(status: ModifyNameStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ModifyNameStatus.unexpectedError));
    }
  }
}
