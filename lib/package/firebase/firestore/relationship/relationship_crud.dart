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

  Future<void> block({
    required String blockerId,
    required String toBlockId,
  }) async {
    final sortedUsers = [blockerId, toBlockId]..sort();

    final RelationshipStatus newStatus;
    if (blockerId == sortedUsers.first) {
      newStatus = RelationshipStatus.blockedByFirst;
    } else if (blockerId == sortedUsers.last) {
      newStatus = RelationshipStatus.blockedByLast;
    } else {
      return;
    }

    final relationshipId = sortedUsers.join();

    final relationship = await read(documentId: relationshipId);
    if (relationship == null) {
      return create(
        documentId: relationshipId,
        data: RelationshipModel(
          id: relationshipId,
          users: sortedUsers,
          status: newStatus,
        ),
      );
    }

    if ([RelationshipStatus.blockedByFirst, RelationshipStatus.blockedByLast]
        .contains(relationship.status)) return;

    await update(
      documentId: relationshipId,
      data: relationship.copyWith(status: newStatus),
    );
  }

  Future<void> cancel({
    required String cancelerId,
    required String otherId,
  }) async {
    final relationshipId = getId(cancelerId, otherId);

    final relationship = await read(documentId: relationshipId);
    if (relationship == null) return;

    if (relationship.status != RelationshipStatus.friends) return;

    final RelationshipStatus newStatus;
    if (cancelerId == relationship.users?.first) {
      newStatus = RelationshipStatus.canceledByFirst;
    } else if (cancelerId == relationship.users?.last) {
      newStatus = RelationshipStatus.canceledByLast;
    } else {
      return;
    }

    await update(
      documentId: relationshipId,
      data: relationship.copyWith(status: newStatus),
    );
  }

  Stream<List<RelationshipModel>> friendsOf(String? userId) {
    return streamFiltered(
      filter: (collection) => collection
          .where('users', arrayContains: userId)
          .where('status', isEqualTo: RelationshipStatus.friends.name),
    );
  }

  String getId(String user1, String user2) {
    final sortedUsers = [user1, user2]..sort();
    return sortedUsers.join();
  }

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
          users: sortedUsers,
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
}

final relationshipCRUD = _RelationshipCRUD();
