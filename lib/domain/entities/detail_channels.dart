import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'detail_channels.freezed.dart';
part 'detail_channels.g.dart';

@freezed
abstract class DetailChannel with _$DetailChannel {
  const factory DetailChannel({
    bool success,
    @nullable String message,
    @nullable @JsonKey(name: 'channels') List<User> user,
  }) = _DetailChannel;

  static const fromJsonFactory = _$DetailChannelFromJson;

  factory DetailChannel.fromJson(Map<String, dynamic> json) =>
      _$DetailChannelFromJson(json);
}
