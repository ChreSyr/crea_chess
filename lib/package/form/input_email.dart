import 'package:crea_chess/package/form/form_error.dart';
import 'package:crea_chess/package/form/input_string.dart';
import 'package:regexpattern/regexpattern.dart';

class InputEmail extends InputString {
  const InputEmail.pure({super.isRequired = false}) : super.pure();

  const InputEmail.dirty({super.string = '', super.isRequired = false})
      : super.dirty();

  @override
  InputEmail copyWith({
    String? string,
    bool? isRequired,
  }) {
    return InputEmail.dirty(
      string: string ?? value,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  FormError? validator(String value) {
    if (value.isEmpty) {
      return isRequired ? FormError.empty : null;
    } else if (!RegExp(RegexPattern.email).hasMatch(value)) {
      return FormError.notEmail;
    }
    return null;
  }
}
