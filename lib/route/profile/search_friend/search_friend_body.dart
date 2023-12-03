import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersCubit extends Cubit<List<UserModel>> {
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
    return BlocBuilder<AllUsersCubit, List<UserModel>>(
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
  if (user.id == null) return Container(); // should never happen
  final relationshipId = relationshipCRUD.getId(currentUserId, user.id!);

  return StreamBuilder<RelationshipModel?>(
    stream: relationshipCRUD.stream(documentId: relationshipId),
    builder: (context, snapshot) {
      Widget? getTrailing() {
        // TODO: if friend request has been sent
        switch (snapshot.data?.status) {
          case null:
          case RelationshipStatus.canceledByFirst:
          case RelationshipStatus.canceledByLast:
            return IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                notificationCRUD.sendFriendRequest(
                  fromUserId: currentUserId,
                  toUserId: user.id,
                );
                snackBarNotify(context, context.l10n.friendRequestSent);
              },
            );
          case RelationshipStatus.friends:
            return const IconButton(
              icon: Icon(Icons.check),
              onPressed: null,
            );
          // TODO: if blocked by current, can unblock
          case RelationshipStatus.blockedByFirst:
          case RelationshipStatus.blockedByLast:
            return const IconButton(
              icon: Icon(Icons.block),
              onPressed: null,
            );
        }
      }

      final trailing = getTrailing();
      if (trailing == null) return Container();

      return ListTile(
        leading: UserProfilePhoto(user.photo),
        title: Text(user.username ?? ''),
        trailing: trailing,
      );
    },
  );
}
