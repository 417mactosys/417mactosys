// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_packages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DetailPackage _$_$_DetailPackageFromJson(Map<String, dynamic> json) {
  return _$_DetailPackage(
    success: json['success'] as bool,
    message: json['message'] as String,
    packages: (json['channels'] as List)
        ?.map((e) =>
            e == null ? null : Package.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_DetailPackageToJson(_$_DetailPackage instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'channels': instance.packages,
    };
