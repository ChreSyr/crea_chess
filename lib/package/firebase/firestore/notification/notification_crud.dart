import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_chess/package/firebase/firestore/crud/base_crud.dart';
import 'package:crea_chess/package/firebase/firestore/crud/model_converter.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_model.dart';

class _NotificationModelConverter implements ModelConverter<NotificationModel> {
  @override
  NotificationModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    return NotificationModel.fromFirestore(snapshot);
  }

  @override
  Map<String, dynamic> toFirestore(NotificationModel data, SetOptions? _) {
    return data.toFirestore();
  }

  @override
  NotificationModel emptyModel() {
    return NotificationModel();
  }
}

class _NotificationCRUD extends BaseCRUD<NotificationModel> {
  _NotificationCRUD() : super('notification', _NotificationModelConverter());

  void sendFriendRequest({
    required String? fromUserId,
    required String? toUserId,
  }) {
    super.create(
      documentId: '$fromUserId$toUserId',
      data: NotificationModel(
        from: fromUserId,
        to: toUserId,
        type: NotificationType.friendRequest,
      ),
    );
  }
}

final notificationCRUD = _NotificationCRUD();
