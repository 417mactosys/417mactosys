// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'packages.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
class _$PackageTearOff {
  const _$PackageTearOff();

// ignore: unused_element
  _Package call({int id, String name, int video_count, int price}) {
    return _Package(
      id: id,
      name: name,
      video_count: video_count,
      price: price,
    );
  }

// ignore: unused_element
  Package fromJson(Map<String, Object> json) {
    return Package.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Package = _$PackageTearOff();

/// @nodoc
mixin _$Package {
  int get id;
  String get name;
  int get video_count;
  int get price;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $PackageCopyWith<Package> get copyWith;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res>;
  $Res call({int id, String name, int video_count, int price});
}

/// @nodoc
class _$PackageCopyWithImpl<$Res> implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  final Package _value;
  // ignore: unused_field
  final $Res Function(Package) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object video_count = freezed,
    Object price = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      video_count:
          video_count == freezed ? _value.video_count : video_count as int,
      price: price == freezed ? _value.price : price as int,
    ));
  }
}

/// @nodoc
abstract class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) then) =
      __$PackageCopyWithImpl<$Res>;
  @override
  $Res call({int id, String name, int video_count, int price});
}

/// @nodoc
class __$PackageCopyWithImpl<$Res> extends _$PackageCopyWithImpl<$Res>
    implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(_Package _value, $Res Function(_Package) _then)
      : super(_value, (v) => _then(v as _Package));

  @override
  _Package get _value => super._value as _Package;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object video_count = freezed,
    Object price = freezed,
  }) {
    return _then(_Package(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      video_count:
          video_count == freezed ? _value.video_count : video_count as int,
      price: price == freezed ? _value.price : price as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Package implements _Package {
  const _$_Package({this.id, this.name, this.video_count, this.price});

  factory _$_Package.fromJson(Map<String, dynamic> json) =>
      _$_$_PackageFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int video_count;
  @override
  final int price;

  @override
  String toString() {
    return 'Package(id: $id, name: $name, video_count: $video_count, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Package &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.video_count, video_count) ||
                const DeepCollectionEquality()
                    .equals(other.video_count, video_count)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(video_count) ^
      const DeepCollectionEquality().hash(price);

  @JsonKey(ignore: true)
  @override
  _$PackageCopyWith<_Package> get copyWith =>
      __$PackageCopyWithImpl<_Package>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PackageToJson(this);
  }
}

abstract class _Package implements Package {
  const factory _Package({int id, String name, int video_count, int price}) =
      _$_Package;

  factory _Package.fromJson(Map<String, dynamic> json) = _$_Package.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get video_count;
  @override
  int get price;
  @override
  @JsonKey(ignore: true)
  _$PackageCopyWith<_Package> get copyWith;
}
