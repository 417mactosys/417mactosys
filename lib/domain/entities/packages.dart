import 'package:freezed_annotation/freezed_annotation.dart';


part 'packages.freezed.dart';
part 'packages.g.dart';

@freezed
abstract class Package with _$Package {
  const factory Package({
    int id,
    String name,
    int video_count,
    int price,

  }) = _Package;
  static const fromJsonFactory = _$PackageFromJson;
  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);
}
