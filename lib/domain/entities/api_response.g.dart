// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ApiResponse _$_$_ApiResponseFromJson(Map<String, dynamic> json) {
  return _$_ApiResponse(
    success: json['success'] as bool,
    message: json['message'] as String,
    uid: json['uid'] as int,
    count: json['count'] as int,
    token: json['token'] as String,
    sid: json['sid'] as String,
    feedid: json['feedid'] as int,
  );
}

Map<String, dynamic> _$_$_ApiResponseToJson(_$_ApiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'uid': instance.uid,
      'count': instance.count,
      'token': instance.token,
      'sid': instance.sid,
      'feedid': instance.feedid,
    };
