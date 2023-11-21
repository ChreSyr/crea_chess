import 'package:crea_chess/package/form/form_error.dart';
import 'package:crea_chess/package/form/input/input_boolean.dart';
import 'package:crea_chess/package/form/input/input_email.dart';
import 'package:crea_chess/package/form/input/input_password.dart';
import 'package:crea_chess/package/form/signup/signup_status.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_form.freezed.dart';

@freezed
class SignupForm with FormzMixin, _$SignupForm {
  factory SignupForm({
    required InputEmail email,
    required InputPassword password,
    required InputBoolean acceptConditions,
    required SignupStatus status,
  }) = _SignupForm;

  /// Required for the override getter
  const SignupForm._();

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        email,
        password,
        acceptConditions,
      ];

  String? errorMessage(
    FormzInput<dynamic, FormError> input,
    AppLocalizations l10n,
  ) {
    if (input.error == null) return null;
    if (status != SignupStatus.editError) return null;
    if (!inputs.contains(input)) return null;

    return l10n.formError(input.error!.name);
  }
}
