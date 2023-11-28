import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_chess/package/firebase/firestore/crud/base_crud.dart';
import 'package:crea_chess/package/firebase/firestore/crud/model_converter.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';

class _UserModelConverter implements ModelConverter<UserModel> {
  @override
  UserModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    return UserModel.fromFirestore(snapshot);
  }

  @override
  Map<String, dynamic> toFirestore(UserModel data, SetOptions? _) {
    return data.toFirestore();
  }

  @override
  UserModel emptyModel() {
    return UserModel();
  }
}

class _UserCRUD extends BaseCRUD<UserModel> {
  _UserCRUD() : super('user', _UserModelConverter());

  final userCubit = UserCubit();

  Future<UserModel?> readUsername(String username) async {
    final users = await readFiltered(
        filter: (collection) =>
            collection.where('username', isEqualTo: username));
    return users.isEmpty ? null : users.first;
  }
}

final userCRUD = _UserCRUD();
