import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.email),
      // TODO: change (load on demain ?)
      title: Text(context.read<AuthenticationCubit>().state?.email ?? ''),
    );
  }
}
