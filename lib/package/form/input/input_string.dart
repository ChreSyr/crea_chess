// ignore_for_file: public_member_api_docs

import 'package:crea_chess/package/form/form_error.dart';
import 'package:formz/formz.dart';

class InputString extends FormzInput<String, FormError> {
  const InputString.pure({this.isRequired = false}) : super.pure('');

  const InputString.dirty({String string = '', this.isRequired = false})
      : super.dirty(string);

  final bool isRequired;

  InputString copyWith({
    String? string,
    bool? isRequired,
  }) {
    return InputString.dirty(
      string: string ?? value,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  FormError? validator(String value) {
    if (value.isEmpty) return isRequired ? FormError.empty : null;
    return null;
  }
}
