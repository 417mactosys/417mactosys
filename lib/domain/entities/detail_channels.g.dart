// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_channels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DetailChannel _$_$_DetailChannelFromJson(Map<String, dynamic> json) {
  return _$_DetailChannel(
    success: json['success'] as bool,
    message: json['message'] as String,
    user: (json['channels'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_DetailChannelToJson(_$_DetailChannel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'channels': instance.user,
    };
