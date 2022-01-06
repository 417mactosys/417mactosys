// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'detail_channels.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DetailChannel _$DetailChannelFromJson(Map<String, dynamic> json) {
  return _DetailChannel.fromJson(json);
}

/// @nodoc
class _$DetailChannelTearOff {
  const _$DetailChannelTearOff();

// ignore: unused_element
  _DetailChannel call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<User> user}) {
    return _DetailChannel(
      success: success,
      message: message,
      user: user,
    );
  }

// ignore: unused_element
  DetailChannel fromJson(Map<String, Object> json) {
    return DetailChannel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $DetailChannel = _$DetailChannelTearOff();

/// @nodoc
mixin _$DetailChannel {
  bool get success;
  @nullable
  String get message;
  @nullable
  @JsonKey(name: 'channels')
  List<User> get user;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $DetailChannelCopyWith<DetailChannel> get copyWith;
}

/// @nodoc
abstract class $DetailChannelCopyWith<$Res> {
  factory $DetailChannelCopyWith(
          DetailChannel value, $Res Function(DetailChannel) then) =
      _$DetailChannelCopyWithImpl<$Res>;
  $Res call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<User> user});
}

/// @nodoc
class _$DetailChannelCopyWithImpl<$Res>
    implements $DetailChannelCopyWith<$Res> {
  _$DetailChannelCopyWithImpl(this._value, this._then);

  final DetailChannel _value;
  // ignore: unused_field
  final $Res Function(DetailChannel) _then;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object user = freezed,
  }) {
    return _then(_value.copyWith(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      user: user == freezed ? _value.user : user as List<User>,
    ));
  }
}

/// @nodoc
abstract class _$DetailChannelCopyWith<$Res>
    implements $DetailChannelCopyWith<$Res> {
  factory _$DetailChannelCopyWith(
          _DetailChannel value, $Res Function(_DetailChannel) then) =
      __$DetailChannelCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<User> user});
}

/// @nodoc
class __$DetailChannelCopyWithImpl<$Res>
    extends _$DetailChannelCopyWithImpl<$Res>
    implements _$DetailChannelCopyWith<$Res> {
  __$DetailChannelCopyWithImpl(
      _DetailChannel _value, $Res Function(_DetailChannel) _then)
      : super(_value, (v) => _then(v as _DetailChannel));

  @override
  _DetailChannel get _value => super._value as _DetailChannel;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object user = freezed,
  }) {
    return _then(_DetailChannel(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      user: user == freezed ? _value.user : user as List<User>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_DetailChannel implements _DetailChannel {
  const _$_DetailChannel(
      {this.success,
      @nullable this.message,
      @nullable @JsonKey(name: 'channels') this.user});

  factory _$_DetailChannel.fromJson(Map<String, dynamic> json) =>
      _$_$_DetailChannelFromJson(json);

  @override
  final bool success;
  @override
  @nullable
  final String message;
  @override
  @nullable
  @JsonKey(name: 'channels')
  final List<User> user;

  @override
  String toString() {
    return 'DetailChannel(success: $success, message: $message, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DetailChannel &&
            (identical(other.success, success) ||
                const DeepCollectionEquality()
                    .equals(other.success, success)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(user);

  @JsonKey(ignore: true)
  @override
  _$DetailChannelCopyWith<_DetailChannel> get copyWith =>
      __$DetailChannelCopyWithImpl<_DetailChannel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DetailChannelToJson(this);
  }
}

abstract class _DetailChannel implements DetailChannel {
  const factory _DetailChannel(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<User> user}) = _$_DetailChannel;

  factory _DetailChannel.fromJson(Map<String, dynamic> json) =
      _$_DetailChannel.fromJson;

  @override
  bool get success;
  @override
  @nullable
  String get message;
  @override
  @nullable
  @JsonKey(name: 'channels')
  List<User> get user;
  @override
  @JsonKey(ignore: true)
  _$DetailChannelCopyWith<_DetailChannel> get copyWith;
}
