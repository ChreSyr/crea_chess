import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_cubit.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_form.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<AlertDialog?> showModifyNameDialog(
  BuildContext context,
  String initialName,
) {
  return showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      final modifyNameCubit = ModifyNameCubit(initialName);

      return BlocProvider(
        create: (context) => modifyNameCubit,
        child: BlocConsumer<ModifyNameCubit, ModifyNameForm>(
          listener: (context, form) {
            switch (form.status) {
              case ModifyNameStatus.unexpectedError:
                snackBarError(
                  context,
                  context.l10n.formError(form.status.name),
                );
                modifyNameCubit.clearFailure();
              case ModifyNameStatus.success:
                context.pop();
              case _:
                break;
            }
          },
          builder: (context, form) {
            return AlertDialog(
              title: const Text(
                "Modifier l'identifiant",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (form.status == ModifyNameStatus.waiting)
                    const LinearProgressIndicator(),
                  TextFormField(
                    autofocus: true,
                    decoration: CCInputDecoration(
                      errorText: form.errorMessage(form.name, context.l10n),
                    ),
                    initialValue: initialName,
                    onChanged: modifyNameCubit.setName,
                    onFieldSubmitted: (val) => modifyNameCubit.submit(),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: context.pop,
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  onPressed: modifyNameCubit.submit,
                  child: const Text('Terminer'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
