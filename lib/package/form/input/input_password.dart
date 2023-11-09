import 'package:crea_chess/package/form/form_error.dart';
import 'package:crea_chess/package/form/input/input_string.dart';
import 'package:regexpattern/regexpattern.dart';

class InputPassword extends InputString {
  const InputPassword.pure({super.isRequired = false}) : super.pure();

  const InputPassword.dirty({super.string = '', super.isRequired = false})
      : super.dirty();

  @override
  InputPassword copyWith({
    String? string,
    bool? isRequired,
  }) {
    return InputPassword.dirty(
      string: string ?? value,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  FormError? validator(String value) {
    if (value.isEmpty) {
      return isRequired ? FormError.empty : null;
    } else if (!RegExp(RegexPattern.passwordNormal3).hasMatch(value)) {
      return FormError.notPassword;
    }
    return null;
  }
}
