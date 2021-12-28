import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';
import 'packages.dart';

part 'detail_packages.freezed.dart';
part 'detail_packages.g.dart';

@freezed
abstract class DetailPackage with _$DetailPackage {
  const factory DetailPackage({
    bool success,
    @nullable String message,
    @nullable @JsonKey(name: 'channels') List<Package> packages,
  }) = _DetailPackage;

  static const fromJsonFactory = _$DetailPackageFromJson;

  factory DetailPackage.fromJson(Map<String, dynamic> json) =>
      _$DetailPackageFromJson(json);
}
