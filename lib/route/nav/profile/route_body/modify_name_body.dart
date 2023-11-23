import 'package:crea_chess/package/atomic_design/field/input_decoration.dart';
import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/snack_bar.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_cubit.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_form.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ModifyNameBody extends RouteBody {
  const ModifyNameBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final initialName = context.read<AuthenticationCubit>().state.name ?? '';
    final modifyNameCubit = ModifyNameCubit(initialName);
    final textController = TextEditingController(text: initialName);

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
              while (context.canPop()) {
                context.pop();
              }
            case _:
              break;
          }
        },
        builder: (context, form) {
          textController.text = form.name.value;

          return SizedBox(
            width: CCWidgetSize.large3,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (form.status == ModifyNameStatus.waiting)
                  const LinearProgressIndicator(),
                // Welcome back !
                const Text(
                  '👀',
                  style: TextStyle(fontSize: CCWidgetSize.xxsmall),
                  textAlign: TextAlign.center,
                ),
                Text(
                  context.l10n.chooseGoodUsername,
                  textAlign: TextAlign.center,
                ),

                CCGap.xlarge,

                // mail field
                TextFormField(
                  autofocus: true,
                  controller: textController,
                  decoration: CCInputDecoration(
                    errorText: form.errorMessage(form.name, context.l10n),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => modifyNameCubit.setName(''),
                    ),
                  ),
                  onChanged: modifyNameCubit.setName,
                ),

                CCGap.xlarge,

                // sign in button
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: modifyNameCubit.submit,
                    child: Text(context.l10n.save),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
