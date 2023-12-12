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
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabIndexCubit extends Cubit<int> {
  TabIndexCubit() : super(0);

  void set(int index) => emit(index);
}

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
    // TODO : AllFriendsCubit
    // TODO: if not friend with him, can only see friends in common
    final tabSections = <String, Widget>{};
    if (userId == currentUserId) {
      tabSections[context.l10n.friends] = UserProfileFriends(user: user);
      tabSections['Détails'] = const UserProfileDetails(); // TODO: l10n
    }
    return BlocProvider(
      create: (context) => TabIndexCubit(),
      child: StreamBuilder<RelationshipModel?>(
        stream: relationshipCRUD.stream(
          documentId: relationshipCRUD.getId(currentUserId, userId),
        ),
        builder: (context, snapshot) {
          final streaming = snapshot.connectionState == ConnectionState.active;
          final relation = snapshot.data;
          // TODO : manage stream errors
          if (userId != currentUserId &&
              relation?.status == RelationshipStatus.friends) {
            tabSections[context.l10n.friends] = UserProfileFriends(user: user);
          }

          return SizedBox(
            width: CCWidgetSize.large4,
            child: DefaultTabController(
              length: tabSections.length,
              child: Column(
                children: [
                  UserProfileHeader(user: user),
                  if (streaming && userId != currentUserId)
                    if (relation == null)
                      SendFriendRequestButton(userId: userId)
                    else
                      UserProfileRelationship(relation),
                  if (tabSections.isNotEmpty) ...[
                    CCGap.medium,
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: tabSections.keys.map((e) => Tab(text: e)).toList(),
                      onTap: context.read<TabIndexCubit>().set,
                    ),
                    CCDivider.xthin,
                    CCPadding.allMedium(
                      child: BlocBuilder<TabIndexCubit, int>(
                        builder: (context, index) {
                          return IndexedStack(
                            alignment: Alignment.topCenter,
                            index: index,
                            children: tabSections.values.toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdaptativeTabBarView extends StatelessWidget {
  const AdaptativeTabBarView({
    required this.controller,
    required this.children,
    super.key,
  });

  final TabController controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
