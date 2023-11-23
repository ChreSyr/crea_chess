// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modify_name_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ModifyNameForm {
  InputString get name => throw _privateConstructorUsedError;
  ModifyNameStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModifyNameFormCopyWith<ModifyNameForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModifyNameFormCopyWith<$Res> {
  factory $ModifyNameFormCopyWith(
          ModifyNameForm value, $Res Function(ModifyNameForm) then) =
      _$ModifyNameFormCopyWithImpl<$Res, ModifyNameForm>;
  @useResult
  $Res call({InputString name, ModifyNameStatus status});
}

/// @nodoc
class _$ModifyNameFormCopyWithImpl<$Res, $Val extends ModifyNameForm>
    implements $ModifyNameFormCopyWith<$Res> {
  _$ModifyNameFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as InputString,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ModifyNameStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModifyNameFormImplCopyWith<$Res>
    implements $ModifyNameFormCopyWith<$Res> {
  factory _$$ModifyNameFormImplCopyWith(_$ModifyNameFormImpl value,
          $Res Function(_$ModifyNameFormImpl) then) =
      __$$ModifyNameFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({InputString name, ModifyNameStatus status});
}

/// @nodoc
class __$$ModifyNameFormImplCopyWithImpl<$Res>
    extends _$ModifyNameFormCopyWithImpl<$Res, _$ModifyNameFormImpl>
    implements _$$ModifyNameFormImplCopyWith<$Res> {
  __$$ModifyNameFormImplCopyWithImpl(
      _$ModifyNameFormImpl _value, $Res Function(_$ModifyNameFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_$ModifyNameFormImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as InputString,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ModifyNameStatus,
    ));
  }
}

/// @nodoc

class _$ModifyNameFormImpl extends _ModifyNameForm {
  _$ModifyNameFormImpl({required this.name, required this.status}) : super._();

  @override
  final InputString name;
  @override
  final ModifyNameStatus status;

  @override
  String toString() {
    return 'ModifyNameForm(name: $name, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModifyNameFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModifyNameFormImplCopyWith<_$ModifyNameFormImpl> get copyWith =>
      __$$ModifyNameFormImplCopyWithImpl<_$ModifyNameFormImpl>(
          this, _$identity);
}

abstract class _ModifyNameForm extends ModifyNameForm {
  factory _ModifyNameForm(
      {required final InputString name,
      required final ModifyNameStatus status}) = _$ModifyNameFormImpl;
  _ModifyNameForm._() : super._();

  @override
  InputString get name;
  @override
  ModifyNameStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ModifyNameFormImplCopyWith<_$ModifyNameFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
