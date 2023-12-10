import 'package:crea_chess/package/atomic_design/padding.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/divider.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_details.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_friends.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_header.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_relationship.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({required this.user, super.key});

  static Widget fromId({required String userId}) {
    return StreamBuilder<UserModel?>(
      stream: userCRUD.stream(documentId: userId),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return const CircularProgressIndicator();
        return UserProfile(user: user);
      },
    );
  }

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserCubit>().state?.id;
    if (currentUserId == null) return Container(); // should never happen
    if (user.id == null) return Container(); // should never happen
    final userId = user.id!;

    return StreamBuilder<RelationshipModel?>(
      stream: relationshipCRUD.stream(
        documentId: relationshipCRUD.getId(currentUserId, userId),
      ),
      builder: (context, snapshot) {
        final relation = snapshot.data;
        return SizedBox(
          width: CCWidgetSize.large3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserProfileHeader(user: user),
              if (relation != null) UserProfileRelationship(relation),
              if (relation?.blocker != userId) ...[
                CCGap.medium,
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          Tab(text: 'Amis'), // TODO : l10n
                          Tab(text: 'Détails'), // TODO : l10n
                        ],
                      ),
                      CCDivider.xthin,
                      CCPadding.allMedium(
                        child: SizedBox(
                          height: 120,
                          child: TabBarView(
                            children: [
                              UserProfileFriends(user: user),
                              if (currentUserId == userId)
                                const UserProfileDetails()
                              else
                                // TODO : l10n
                                const Text('Aucun détail disponible'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
