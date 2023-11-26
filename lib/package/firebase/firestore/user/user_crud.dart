import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_chess/package/firebase/firestore/crud/base_crud.dart';
import 'package:crea_chess/package/firebase/firestore/crud/model_converter.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';

class UserModelConverter implements ModelConverter<UserModel> {
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
  _UserCRUD() : super('user', UserModelConverter());

  final userCubit = UserCubit();
}

final userCRUD = _UserCRUD();
