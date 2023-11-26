import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/route/profile/body_template.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchFriendBody extends RouteBody {
  const SearchFriendBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return 'Rechercher un ami'; // TODO: l10n
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return BodyTemplate(
      loading: false,
      emoji: '🔍',
      title: "Enter your friend's name.",
      children: [
        TextFormField(
          autofocus: true,
          controller: textController,
          decoration: CCInputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => null, // modifyUsernameCubit.setName(''),
            ),
          ),
          // onChanged: modifyUsernameCubit.setName,
        ),
      ],
    );
  }
}
