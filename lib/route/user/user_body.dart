import 'package:crea_chess/package/atomic_design/streamer/streamer.dart';
import 'package:crea_chess/package/atomic_design/widget/user/relationship_button.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_header.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_profile.dart';
import 'package:crea_chess/package/atomic_design/widget/user/user_sections.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_crud.dart';
import 'package:crea_chess/package/firebase/firestore/relationship/relationship_model.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_cubit.dart';
import 'package:crea_chess/package/firebase/firestore/user/user_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/nav_notif_cubit.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// LATER: welcome and connect page when it is the first opening of the app
// LATER: App Check

class UserBody extends MainRouteBody {
  const UserBody({this.routeUserId, super.key})
      : super(id: 'user', icon: Icons.person, centered: false, padded: false);

  final String? routeUserId;

  @override
  String getTitle(AppLocalizations l10n) => l10n.profile;

  static const notifEmailNotVerified = 'email-not-verified';
  static const notifPhotoEmpty = 'photo-empty';
  static const notifNameEmpty = 'name-empty';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, User?>(
      builder: (context, auth) {
        if (auth != null && !auth.isVerified) {
          context.read<NavNotifCubit>().add(id, notifEmailNotVerified);
        } else {
          context.read<NavNotifCubit>().remove(id, notifEmailNotVerified);
        }

        // Note : if auth is null, the sso route replaces the user route.
        // This is just a security.
        if (auth == null) {
          return Center(
            child: FilledButton.icon(
              onPressed: () => context.push('/sso'),
              icon: const Icon(Icons.login),
              label: Text(context.l10n.signin),
            ),
          );

          // If the email is not confirmed yet
          // LATER: rethink : authenticated simply with phone ?
        } else if (!auth.isVerified) {
          return UserProfile(
            header: UserHeader.notVerified(authUid: auth.uid),
            tabSections: UserSection.getNotVerifiedSections(),
          );
        }

        final currentUserId = auth.uid;
        final userId = routeUserId ?? currentUserId;

        if (currentUserId != userId) {
          return Streamer.user(
            userId: userId,
            builder: (_, user) {
              final relationshipWidget = StreamBuilder<RelationshipModel?>(
                stream: relationshipCRUD.stream(
                  documentId: relationshipCRUD.getId(currentUserId, userId),
                ),
                builder: (context, snapshot) {
                  final streaming =
                      snapshot.connectionState == ConnectionState.active;
                  final relation = snapshot.data ??
                      RelationshipModel(users: [userId, currentUserId]);

                  return (streaming && userId != currentUserId
                          ? getRelationshipButton(context, relation)
                          : null) ??
                      Container();
                },
              );

              return UserProfile(
                header: UserHeader(
                  userId: userId,
                  banner: user.banner,
                  photo: user.photo,
                  username: user.username,
                  editable: false,
                ),
                relationshipWidget: relationshipWidget,
                tabSections: UserSection.getSections(currentUserId, userId),
              );
            },
          );
        }

        return BlocConsumer<UserCubit, UserModel?>(
          listener: (context, user) {
            if (user == null) {
              context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              context.read<NavNotifCubit>().remove(id, notifNameEmpty);
            } else {
              if ((user.photo ?? '').isEmpty) {
                context.read<NavNotifCubit>().add(id, notifPhotoEmpty);
              } else {
                context.read<NavNotifCubit>().remove(id, notifPhotoEmpty);
              }
              if ((user.username ?? '').isEmpty || user.username == user.id) {
                context.read<NavNotifCubit>().add(id, notifNameEmpty);
              } else {
                context.read<NavNotifCubit>().remove(id, notifNameEmpty);
              }
            }
          },
          builder: (context, user) {
            // creating the user
            if (user == null) return const CircularProgressIndicator();

            return UserProfile(
              header: UserHeader(
                userId: userId,
                banner: user.banner,
                photo: user.photo,
                username: user.username,
                editable: true,
              ),
              tabSections: UserSection.getSections(currentUserId, userId),
            );
          },
        );
      },
    );
  }
}
