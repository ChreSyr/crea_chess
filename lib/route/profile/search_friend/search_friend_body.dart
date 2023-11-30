import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_crud.dart';
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
        if (query.isEmpty) return Container();
        return ListView(
          children: users
              .where(
                (user) =>
                    user != currentUser &&
                    (user.usernameLowercase?.contains(query.toLowerCase()) ??
                        false),
              )
              .map<Widget>(UserTile.new)
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
    // final matchQuery = <String>[];
    // for (final user in searchTerms) {
    //   if (user.toLowerCase().contains(query.toLowerCase())) {
    //     matchQuery.add(user);
    //   }
    // }
    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     final result = matchQuery[index];
    //     return ListTile(
    //       title: Text(result),
    //     );
    //   },
    // );
  }
}

class UserTile extends StatelessWidget {
  const UserTile(this.user, {super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    // TODO : different if friend, blocked, unknown...
    return ListTile(
      leading: UserProfilePhoto(user.photo),
      title: Text(user.username ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          final currentUser = context.read<UserCubit>().state;
          if (currentUser == null) return;
          notificationCRUD.sendFriendRequest(
            fromUserId: currentUser.id,
            toUserId: user.id,
          );
          snackBarNotify(context, context.l10n.friendRequestSent);
        },
      ),
    );
  }
}
