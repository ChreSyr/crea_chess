import 'package:crea_chess/package/form/form_error.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:crea_chess/package/form/modify_name/modify_name_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'modify_name_form.freezed.dart';

@freezed
class ModifyNameForm with FormzMixin, _$ModifyNameForm {
  factory ModifyNameForm({
    required InputString name,
    required ModifyNameStatus status,
  }) = _ModifyNameForm;

  /// Required for the override getter
  const ModifyNameForm._();

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [name];

  String? errorMessage(
    FormzInput<dynamic, FormError> input,
    AppLocalizations l10n,
  ) {
    if (input.error == null) return null;
    if (status != ModifyNameStatus.editError) return null;
    if (!inputs.contains(input)) return null;

    return l10n.formError(input.error!.name);
  }
}
