// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Feed _$_$_FeedFromJson(Map<String, dynamic> json) {
  return _$_Feed(
    id: json['id'] as int,
    image: json['image'] as String,
    thumbnail: json['thumbnail'] as String ?? '',
    body: json['body'] as String,
    date: json['date'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    likes: json['likes'] as int,
    liked: json['liked'] as int,
    comments: json['comments'] as int,
    is_live: json['is_live'] as int,
    live_ended: json['live_ended'] as int ?? 1,
    channel_name: json['channel_name'] as String,
    sid: json['sid'] as String,
    category_id: json['category_id'] as int,
  );
}

Map<String, dynamic> _$_$_FeedToJson(_$_Feed instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'thumbnail': instance.thumbnail,
      'body': instance.body,
      'date': instance.date,
      'user': instance.user,
      'likes': instance.likes,
      'liked': instance.liked,
      'comments': instance.comments,
      'is_live': instance.is_live,
      'live_ended': instance.live_ended,
      'channel_name': instance.channel_name,
      'sid': instance.sid,
      'category_id': instance.category_id,
    };
