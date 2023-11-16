// ignore_for_file: invalid_annotation_target, flutter_style_todos

import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_where.freezed.dart';

@freezed
class FirestoreWhereModel with _$FirestoreWhereModel {
  factory FirestoreWhereModel({
    required Object field,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) = _FirestoreWhereModel;
}
