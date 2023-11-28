// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipModelImpl _$$RelationshipModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RelationshipModelImpl(
      id: json['id'] as String?,
      ref: json['ref'] as String?,
      users:
          (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: $enumDecodeNullable(_$RelationshipStatusEnumMap, json['status']),
      games:
          (json['games'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$RelationshipModelImplToJson(
        _$RelationshipModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ref': instance.ref,
      'users': instance.users,
      'status': _$RelationshipStatusEnumMap[instance.status],
      'games': instance.games,
    };

const _$RelationshipStatusEnumMap = {
  RelationshipStatus.friends: 'friends',
  RelationshipStatus.canceledByUser1: 'canceledByUser1',
  RelationshipStatus.canceledByUser2: 'canceledByUser2',
  RelationshipStatus.blockedByUser1: 'blockedByUser1',
  RelationshipStatus.blockedByUser2: 'blockedByUser2',
};
