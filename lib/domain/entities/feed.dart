import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

@freezed
abstract class Feed with _$Feed {
  const factory Feed({
    int id,
    @nullable String image,
    @nullable @Default("") String thumbnail,
    @nullable String body,
    @nullable String date,
    @nullable User user,
    @nullable int likes,
    @nullable int liked,
    @nullable int comments,
    @nullable int is_live,
    @nullable @Default(1) int live_ended,
    @nullable String channel_name,
    @nullable String sid,
    @nullable int category_id,
  }) = _Feed;
  static const fromJsonFactory = _$FeedFromJson;
  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
}
