// ignore_for_file: public_member_api_docs, invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  friendRequest,
}

@freezed
class NotificationModel with _$NotificationModel {
  factory NotificationModel({
    String? id,
    String? ref,
    NotificationType? type,
    String? from,
    String? to,
  }) = _NotificationModel;

  /// Required for the override getter
  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return NotificationModel.fromJson(doc.data() ?? {})
        .copyWith(id: doc.id, ref: doc.reference.path);
  }

  Map<String, dynamic> toFirestore() {
    return toJson()
      ..removeWhere((key, value) {
        return key == 'id' || key == 'ref' || value == null;
      });
  }
}
