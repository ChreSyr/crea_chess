import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crea_chess/package/firebase/firestore/crud/base_crud.dart';
import 'package:crea_chess/package/firebase/firestore/crud/model_converter.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';

class _RelationshipModelConverter implements ModelConverter<RelationshipModel> {
  @override
  RelationshipModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    return RelationshipModel.fromFirestore(snapshot);
  }

  @override
  Map<String, dynamic> toFirestore(RelationshipModel data, SetOptions? _) {
    return data.toFirestore();
  }

  @override
  RelationshipModel emptyModel() {
    return RelationshipModel();
  }
}

class _RelationshipCRUD extends BaseCRUD<RelationshipModel> {
  _RelationshipCRUD() : super('relationship', _RelationshipModelConverter());

  Future<void> makeFriends(String user1, String user2) async {
    final sortedUsers = [user1, user2]..sort();
    final relationshipId = sortedUsers.join();
    final relation = await read(documentId: relationshipId);
    if (relation != null) {
      if (relation.status != RelationshipStatus.friends) {
        await super.update(
          documentId: relationshipId,
          data: relation.copyWith(status: RelationshipStatus.friends),
        );
      }
    } else {
        await super.create(
          documentId: relationshipId,
          data: RelationshipModel(
            users: [user1, user2],
            status: RelationshipStatus.friends,
          ),
        );

        final friendRequest1 = await notificationCRUD.read(
          documentId: [user1, user2].join(),
        );
        if (friendRequest1 != null) {
          await notificationCRUD.delete(documentId: friendRequest1.id);
        }

        final friendRequest2 = await notificationCRUD.read(
          documentId: [user2, user1].join(),
        );
        if (friendRequest2 != null) {
          await notificationCRUD.delete(documentId: friendRequest2.id);
        }
    }
  }

  void canceledBy(String canceledBy, {required String relationshipId}) {
    // TODO
    // If was acepted, cancelByUserX
    // Else, delete friend request
  }
}

final relationshipCRUD = _RelationshipCRUD();
