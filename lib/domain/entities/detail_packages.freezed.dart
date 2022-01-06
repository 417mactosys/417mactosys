// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'detail_packages.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DetailPackage _$DetailPackageFromJson(Map<String, dynamic> json) {
  return _DetailPackage.fromJson(json);
}

/// @nodoc
class _$DetailPackageTearOff {
  const _$DetailPackageTearOff();

// ignore: unused_element
  _DetailPackage call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<Package> packages}) {
    return _DetailPackage(
      success: success,
      message: message,
      packages: packages,
    );
  }

// ignore: unused_element
  DetailPackage fromJson(Map<String, Object> json) {
    return DetailPackage.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $DetailPackage = _$DetailPackageTearOff();

/// @nodoc
mixin _$DetailPackage {
  bool get success;
  @nullable
  String get message;
  @nullable
  @JsonKey(name: 'channels')
  List<Package> get packages;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $DetailPackageCopyWith<DetailPackage> get copyWith;
}

/// @nodoc
abstract class $DetailPackageCopyWith<$Res> {
  factory $DetailPackageCopyWith(
          DetailPackage value, $Res Function(DetailPackage) then) =
      _$DetailPackageCopyWithImpl<$Res>;
  $Res call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<Package> packages});
}

/// @nodoc
class _$DetailPackageCopyWithImpl<$Res>
    implements $DetailPackageCopyWith<$Res> {
  _$DetailPackageCopyWithImpl(this._value, this._then);

  final DetailPackage _value;
  // ignore: unused_field
  final $Res Function(DetailPackage) _then;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object packages = freezed,
  }) {
    return _then(_value.copyWith(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      packages:
          packages == freezed ? _value.packages : packages as List<Package>,
    ));
  }
}

/// @nodoc
abstract class _$DetailPackageCopyWith<$Res>
    implements $DetailPackageCopyWith<$Res> {
  factory _$DetailPackageCopyWith(
          _DetailPackage value, $Res Function(_DetailPackage) then) =
      __$DetailPackageCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool success,
      @nullable String message,
      @nullable @JsonKey(name: 'channels') List<Package> packages});
}

/// @nodoc
class __$DetailPackageCopyWithImpl<$Res>
    extends _$DetailPackageCopyWithImpl<$Res>
    implements _$DetailPackageCopyWith<$Res> {
  __$DetailPackageCopyWithImpl(
      _DetailPackage _value, $Res Function(_DetailPackage) _then)
      : super(_value, (v) => _then(v as _DetailPackage));

  @override
  _DetailPackage get _value => super._value as _DetailPackage;

  @override
  $Res call({
    Object success = freezed,
    Object message = freezed,
    Object packages = freezed,
  }) {
    return _then(_DetailPackage(
      success: success == freezed ? _value.success : success as bool,
      message: message == freezed ? _value.message : message as String,
      packages:
          packages == freezed ? _value.packages : packages as List<Package>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_DetailPackage implements _DetailPackage {
  const _$_DetailPackage(
      {this.success,
      @nullable this.message,
      @nullable @JsonKey(name: 'channels') this.packages});

  factory _$_DetailPackage.fromJson(Map<String, dynamic> json) =>
      _$_$_DetailPackageFromJson(json);

  @override
  final bool success;
  @override
  @nullable
  final String message;
  @override
  @nullable
  @JsonKey(name: 'channels')
  final List<Package> packages;

  @override
  String toString() {
    return 'DetailPackage(success: $success, message: $message, packages: $packages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DetailPackage &&
            (identical(other.success, success) ||
                const DeepCollectionEquality()
                    .equals(other.success, success)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.packages, packages) ||
                const DeepCollectionEquality()
                    .equals(other.packages, packages)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(packages);

  @JsonKey(ignore: true)
  @override
  _$DetailPackageCopyWith<_DetailPackage> get copyWith =>
      __$DetailPackageCopyWithImpl<_DetailPackage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DetailPackageToJson(this);
  }
}

abstract class _DetailPackage implements DetailPackage {
  const factory _DetailPackage(
          {bool success,
          @nullable String message,
          @nullable @JsonKey(name: 'channels') List<Package> packages}) =
      _$_DetailPackage;

  factory _DetailPackage.fromJson(Map<String, dynamic> json) =
      _$_DetailPackage.fromJson;

  @override
  bool get success;
  @override
  @nullable
  String get message;
  @override
  @nullable
  @JsonKey(name: 'channels')
  List<Package> get packages;
  @override
  @JsonKey(ignore: true)
  _$DetailPackageCopyWith<_DetailPackage> get copyWith;
}
