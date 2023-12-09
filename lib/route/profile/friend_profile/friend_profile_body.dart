import 'package:crea_chess/package/atomic_design/widget/user/user_profile.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:crea_chess/route/router.dart';
import 'package:flutter/material.dart';

class FriendProfileBody extends RouteBody {
  const FriendProfileBody({required this.friendId, super.key})
      : super(padded: false, centered: false);

  final String friendId;

  @override
  String getTitle(AppLocalizations l10n) => '';

  @override
  Widget build(BuildContext context) {
    if (friendId.isEmpty) {
      return ErrorBody(exception: Exception('No friendId provided'));
    }
    return UserProfile.fromId(userId: friendId);
  }
}
