import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
abstract class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    bool success,
    @nullable String message,
    @nullable int uid,
    @nullable int count,
    @nullable String token,
    @nullable String sid,
    @nullable int feedid,
  }) = _ApiResponse;
  static const fromJsonFactory = _$ApiResponseFromJson;
  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}
