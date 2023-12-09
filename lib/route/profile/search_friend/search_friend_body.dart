import 'package:crea_chess/package/atomic_design/dialog/relationship/unblock_user_dialog.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/simple_badge.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AllUsersCubit extends Cubit<Iterable<UserModel>> {
  AllUsersCubit() : super([]);

  Future<void> load() async {
    try {
      final users = await userCRUD.readFiltered(
        filter: (collection) => collection,
      );
      emit(users);
    } catch (_) {}
  }

  void clear() => emit([]);

  late final List<UserModel> allUsers;
}

void searchFriend(BuildContext context) {
  context.read<AllUsersCubit>().load();
  showSearch(
    context: context,
    delegate: FriendSearchDelegate(
      context.l10n,
      currentUser: context.read<UserCubit>().state,
    ),
  );
}

class FriendSearchDelegate extends SearchDelegate<String?> {
  FriendSearchDelegate(AppLocalizations l10n, {this.currentUser})
      : super(searchFieldLabel: l10n.searchUsername);

  final UserModel? currentUser;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : null,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(border: InputBorder.none),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        context.read<AllUsersCubit>().clear();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<AllUsersCubit, Iterable<UserModel>>(
      builder: (context, users) {
        if (users.isEmpty) return const LinearProgressIndicator();
        // if (query.isEmpty) return Container();
        return ListView(
          children: users
              .where(
                (user) =>
                    user != currentUser &&
                    (user.usernameLowercase?.contains(query.toLowerCase()) ??
                        false),
              )
              .map<Widget>((user) => getUserTile(context, user))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

Widget getUserTile(BuildContext context, UserModel user) {
  final currentUserId = context.read<UserCubit>().state?.id;
  if (currentUserId == null) return Container(); // should never happen
  final userId = user.id;
  if (userId == null) return Container(); // should never happen
  final relationshipId = relationshipCRUD.getId(currentUserId, userId);

  return StreamBuilder<RelationshipModel?>(
    stream: relationshipCRUD.stream(documentId: relationshipId),
    builder: (context, snapshot) {
      Widget getTrailing() {
        final relationship = snapshot.data;
        final sendRequestButton = IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            relationshipCRUD.sendFriendRequest(
              fromUserId: currentUserId,
              toUserId: userId,
            );
            snackBarNotify(context, context.l10n.friendRequestSent);
          },
        );

        if (relationship == null) return sendRequestButton;
        switch (relationship.status) {
          case null:
          case RelationshipStatus.canceled:
            return sendRequestButton;
          case RelationshipStatus.requestedByFirst:
          case RelationshipStatus.requestedByLast:
            final canAccept = relationship.isRequestedBy(userId);
            return canAccept
                ? SimpleIconButtonBadge(
                    child: IconButton(
                      onPressed: () => answerFriendRequest(
                        context,
                        relationship.requester,
                      ),
                      icon: const Icon(Icons.mail),
                    ),
                  )
                : const IconButton(onPressed: null, icon: Icon(Icons.send));
          case RelationshipStatus.friends:
            return const IconButton(
              icon: Icon(Icons.check),
              onPressed: null,
            );
          case RelationshipStatus.blockedByFirst:
          case RelationshipStatus.blockedByLast:
            return IconButton(
              icon: const Icon(Icons.block),
              onPressed: relationship.isBlockedBy(userId)
                  ? null
                  : () => showUnblockUserDialog(
                        context,
                        currentUserId,
                        userId,
                      ),
            );
        }
      }

      final trailing = getTrailing();

      return ListTile(
        leading: UserProfilePhoto(user.photo),
        title: Text(user.username ?? ''),
        trailing: trailing,
        onTap: () => context.push('/profile/friend_profile/${userId}'),
      );
    },
  );
}
