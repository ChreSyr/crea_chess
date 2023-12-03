// ignore_for_file: public_member_api_docs, invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_model.freezed.dart';
part 'relationship_model.g.dart';

enum RelationshipStatus {
  friends,
  canceledByFirst,
  canceledByLast,
  blockedByFirst,
  blockedByLast,
}

@freezed
class RelationshipModel with _$RelationshipModel {
  factory RelationshipModel({
    String? id,
    String? ref,
    List<String>? users,
    RelationshipStatus? status,
    List<String>? games,
  }) = _RelationshipModel;

  /// Required for the override getter
  const RelationshipModel._();

  factory RelationshipModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipModelFromJson(json);

  factory RelationshipModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return RelationshipModel.fromJson(doc.data() ?? {})
        .copyWith(id: doc.id, ref: doc.reference.path);
  }

  Map<String, dynamic> toFirestore() {
    return toJson()
      ..removeWhere((key, value) {
        return key == 'id' || key == 'ref' || value == null;
      });
  }
}
