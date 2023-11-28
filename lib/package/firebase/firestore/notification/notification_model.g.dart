// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String?,
      ref: json['ref'] as String?,
      type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']),
      from: json['from'] as String?,
      to: json['to'] as String?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ref': instance.ref,
      'type': _$NotificationTypeEnumMap[instance.type],
      'from': instance.from,
      'to': instance.to,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.friendRequest: 'friendRequest',
};
