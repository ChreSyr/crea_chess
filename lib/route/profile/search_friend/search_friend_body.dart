import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/firestore/notification/notification_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_crud.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/profile/body_template.dart';
import 'package:crea_chess/route/profile/profile/profile_photo.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<List<UserModel>> {
  UsersCubit() : super([]) {
    _init();
  }

  Future<void> _init() async {
    try {
      final users = await userCRUD.readFiltered(
        filter: (collection) => collection,
      );
      emit(users);
    } catch (_) {
      rethrow;
    }
  }

  late final List<UserModel> allUsers;
}

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void search(String search) => emit(search.toLowerCase());
}

class SearchFriendBody extends RouteBody {
  const SearchFriendBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return 'Ajouter un ami'; // TODO: l10n
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserCubit>().state;
    final textController = TextEditingController();
    final usersCubit = UsersCubit();
    final searchCubit = SearchCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => usersCubit,
        ),
        BlocProvider(
          create: (context) => searchCubit,
        ),
      ],
      child: BlocBuilder<SearchCubit, String>(
        builder: (context, search) {
          return BodyTemplate(
            loading: false,
            emoji: '🔍',
            title: "Enter your friend's username.",
            children: [
              TextFormField(
                autofocus: true,
                controller: textController,
                decoration: CCInputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => searchCubit.search(''),
                  ),
                ),
                onChanged: searchCubit.search,
              ),
              CCGap.large,
              BlocBuilder<UsersCubit, List<UserModel>>(
                builder: (context, users) {
                  if (users.isEmpty) return const LinearProgressIndicator();
                  if (search.isEmpty) return Container();
                  return Column(
                    children: users
                        .where(
                          (user) =>
                              user != currentUser &&
                              (user.usernameLowercase?.startsWith(search) ??
                                  false),
                        )
                        .map<Widget>(UserTile.new)
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile(this.user, {super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    // TODO : different if friend, blocked, unknown...
    return ListTile(
      leading: UserAvatar(user.photo
      ),
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
          snackBarNotify(context, 'Demande en ami envoyée'); // TODO: l10n
        },
      ),
    );
  }
}
