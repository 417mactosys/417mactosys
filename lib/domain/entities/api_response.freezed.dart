// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse.fromJson(json);
}

/// @nodoc
class _$ApiResponseTearOff {
  const _$ApiResponseTearOff();

// ignore: unused_element
  _ApiResponse call(
      {bool success,
      @nullable String message,
      @nullable int uid,
      @nullable int count,
      @nullable String token,
      @nullable String sid,
      @nullable int feedid}) {
    return _ApiResponse(
      success: success,
      message: message,
      uid: uid,
      count: count,
      token: token,
      sid: sid,
      feedid: feedid,
    );
  }

// ignore: unused_element
  ApiResponse fromJson(Map<String, Object> json) {
    return ApiResponse.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ApiResponse = _$ApiResponseTearOff();

/// @nodoc
mixin _$ApiResponse {
  bool get success;
  @nullable
  String get message;
  @nullable
  int get uid;
  @nullable
  int get count;
  @nullable
  String get token;
  @nullable
  String get sid;
  @nullable
  int get feedid;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $ApiResponseCopyWith<ApiResponse> get copyWith;
}

/// @nodoc
abstract class $ApiResponseCopyWith<$Res> {
  factory $ApiResponseCopyWith(
          ApiResponse value, $Res Function(ApiResponse) then) =
      _$ApiResponseCopyWithImpl<$Res>;
  $Res call(
      {bool success,
      @nullable String message,
      @nullable int uid,
      @nullable int count,
      @nullable String token,
      @nullable String sid,
      @nullable int feedid});
}

/// @nodoc
class _$ApiResponseCopyWithImpl<$Res> implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  final ApiResponse _value;
  // ignore: unused_field
  final $Res Function(ApiResponse) _then;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object uid = freezed,
    Object count = freezed,
    Object token = freezed,
    Object sid = freezed,
    Object feedid = freezed,
  }) {
    return _then(_value.copyWith(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      uid: uid == freezed ? _value.uid : uid as int,
      count: count == freezed ? _value.count : count as int,
      token: token == freezed ? _value.token : token as String,
      sid: sid == freezed ? _value.sid : sid as String,
      feedid: feedid == freezed ? _value.feedid : feedid as int,
    ));
  }
}

/// @nodoc
abstract class _$ApiResponseCopyWith<$Res>
    implements $ApiResponseCopyWith<$Res> {
  factory _$ApiResponseCopyWith(
          _ApiResponse value, $Res Function(_ApiResponse) then) =
      __$ApiResponseCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool success,
      @nullable String message,
      @nullable int uid,
      @nullable int count,
      @nullable String token,
      @nullable String sid,
      @nullable int feedid});
}

/// @nodoc
class __$ApiResponseCopyWithImpl<$Res> extends _$ApiResponseCopyWithImpl<$Res>
    implements _$ApiResponseCopyWith<$Res> {
  __$ApiResponseCopyWithImpl(
      _ApiResponse _value, $Res Function(_ApiResponse) _then)
      : super(_value, (v) => _then(v as _ApiResponse));

  @override
  _ApiResponse get _value => super._value as _ApiResponse;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object uid = freezed,
    Object count = freezed,
    Object token = freezed,
    Object sid = freezed,
    Object feedid = freezed,
  }) {
    return _then(_ApiResponse(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      uid: uid == freezed ? _value.uid : uid as int,
      count: count == freezed ? _value.count : count as int,
      token: token == freezed ? _value.token : token as String,
      sid: sid == freezed ? _value.sid : sid as String,
      feedid: feedid == freezed ? _value.feedid : feedid as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ApiResponse implements _ApiResponse {
  const _$_ApiResponse(
      {this.success,
      @nullable this.message,
      @nullable this.uid,
      @nullable this.count,
      @nullable this.token,
      @nullable this.sid,
      @nullable this.feedid});

  factory _$_ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$_$_ApiResponseFromJson(json);

  @override
  final bool success;
  @override
  @nullable
  final String message;
  @override
  @nullable
  final int uid;
  @override
  @nullable
  final int count;
  @override
  @nullable
  final String token;
  @override
  @nullable
  final String sid;
  @override
  @nullable
  final int feedid;

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, uid: $uid, count: $count, token: $token, sid: $sid, feedid: $feedid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ApiResponse &&
            (identical(other.success, success) ||
                const DeepCollectionEquality()
                    .equals(other.success, success)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.sid, sid) ||
                const DeepCollectionEquality().equals(other.sid, sid)) &&
            (identical(other.feedid, feedid) ||
                const DeepCollectionEquality().equals(other.feedid, feedid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(count) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(sid) ^
      const DeepCollectionEquality().hash(feedid);

  @JsonKey(ignore: true)
  @override
  _$ApiResponseCopyWith<_ApiResponse> get copyWith =>
      __$ApiResponseCopyWithImpl<_ApiResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ApiResponseToJson(this);
  }
}

abstract class _ApiResponse implements ApiResponse {
  const factory _ApiResponse(
      {bool success,
      @nullable String message,
      @nullable int uid,
      @nullable int count,
      @nullable String token,
      @nullable String sid,
      @nullable int feedid}) = _$_ApiResponse;

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =
      _$_ApiResponse.fromJson;

  @override
  bool get success;
  @override
  @nullable
  String get message;
  @override
  @nullable
  int get uid;
  @override
  @nullable
  int get count;
  @override
  @nullable
  String get token;
  @override
  @nullable
  String get sid;
  @override
  @nullable
  int get feedid;
  @override
  @JsonKey(ignore: true)
  _$ApiResponseCopyWith<_ApiResponse> get copyWith;
}
