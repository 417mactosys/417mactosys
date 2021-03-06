// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Feed _$FeedFromJson(Map<String, dynamic> json) {
  return _Feed.fromJson(json);
}

/// @nodoc
class _$FeedTearOff {
  const _$FeedTearOff();

// ignore: unused_element
  _Feed call(
      {int id,
      @nullable String image,
      @nullable String thumbnail = '',
      @nullable String body,
      @nullable String date,
      @nullable User user,
      @nullable int likes,
      @nullable int liked,
      @nullable int comments,
      @nullable int is_live,
      @nullable int live_ended = 1,
      @nullable String channel_name,
      @nullable String sid,
      @nullable int category_id}) {
    return _Feed(
      id: id,
      image: image,
      thumbnail: thumbnail,
      body: body,
      date: date,
      user: user,
      likes: likes,
      liked: liked,
      comments: comments,
      is_live: is_live,
      live_ended: live_ended,
      channel_name: channel_name,
      sid: sid,
      category_id: category_id,
    );
  }

// ignore: unused_element
  Feed fromJson(Map<String, Object> json) {
    return Feed.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Feed = _$FeedTearOff();

/// @nodoc
mixin _$Feed {
  int get id;
  @nullable
  String get image;
  @nullable
  String get thumbnail;
  @nullable
  String get body;
  @nullable
  String get date;
  @nullable
  User get user;
  @nullable
  int get likes;
  @nullable
  int get liked;
  @nullable
  int get comments;
  @nullable
  int get is_live;
  @nullable
  int get live_ended;
  @nullable
  String get channel_name;
  @nullable
  String get sid;
  @nullable
  int get category_id;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $FeedCopyWith<Feed> get copyWith;
}

/// @nodoc
abstract class $FeedCopyWith<$Res> {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) then) =
      _$FeedCopyWithImpl<$Res>;
  $Res call(
      {int id,
      @nullable String image,
      @nullable String thumbnail,
      @nullable String body,
      @nullable String date,
      @nullable User user,
      @nullable int likes,
      @nullable int liked,
      @nullable int comments,
      @nullable int is_live,
      @nullable int live_ended,
      @nullable String channel_name,
      @nullable String sid,
      @nullable int category_id});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$FeedCopyWithImpl<$Res> implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._value, this._then);

  final Feed _value;
  // ignore: unused_field
  final $Res Function(Feed) _then;

  @override
  $Res call({
    Object id = freezed,
    Object image = freezed,
    Object thumbnail = freezed,
    Object body = freezed,
    Object date = freezed,
    Object user = freezed,
    Object likes = freezed,
    Object liked = freezed,
    Object comments = freezed,
    Object is_live = freezed,
    Object live_ended = freezed,
    Object channel_name = freezed,
    Object sid = freezed,
    Object category_id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      image: image == freezed ? _value.image : image as String,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String,
      body: body == freezed ? _value.body : body as String,
      date: date == freezed ? _value.date : date as String,
      user: user == freezed ? _value.user : user as User,
      likes: likes == freezed ? _value.likes : likes as int,
      liked: liked == freezed ? _value.liked : liked as int,
      comments: comments == freezed ? _value.comments : comments as int,
      is_live: is_live == freezed ? _value.is_live : is_live as int,
      live_ended: live_ended == freezed ? _value.live_ended : live_ended as int,
      channel_name: channel_name == freezed
          ? _value.channel_name
          : channel_name as String,
      sid: sid == freezed ? _value.sid : sid as String,
      category_id:
          category_id == freezed ? _value.category_id : category_id as int,
    ));
  }

  @override
  $UserCopyWith<$Res> get user {
    if (_value.user == null) {
      return null;
    }
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
abstract class _$FeedCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$FeedCopyWith(_Feed value, $Res Function(_Feed) then) =
      __$FeedCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      @nullable String image,
      @nullable String thumbnail,
      @nullable String body,
      @nullable String date,
      @nullable User user,
      @nullable int likes,
      @nullable int liked,
      @nullable int comments,
      @nullable int is_live,
      @nullable int live_ended,
      @nullable String channel_name,
      @nullable String sid,
      @nullable int category_id});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$FeedCopyWithImpl<$Res> extends _$FeedCopyWithImpl<$Res>
    implements _$FeedCopyWith<$Res> {
  __$FeedCopyWithImpl(_Feed _value, $Res Function(_Feed) _then)
      : super(_value, (v) => _then(v as _Feed));

  @override
  _Feed get _value => super._value as _Feed;

  @override
  $Res call({
    Object id = freezed,
    Object image = freezed,
    Object thumbnail = freezed,
    Object body = freezed,
    Object date = freezed,
    Object user = freezed,
    Object likes = freezed,
    Object liked = freezed,
    Object comments = freezed,
    Object is_live = freezed,
    Object live_ended = freezed,
    Object channel_name = freezed,
    Object sid = freezed,
    Object category_id = freezed,
  }) {
    return _then(_Feed(
      id: id == freezed ? _value.id : id as int,
      image: image == freezed ? _value.image : image as String,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String,
      body: body == freezed ? _value.body : body as String,
      date: date == freezed ? _value.date : date as String,
      user: user == freezed ? _value.user : user as User,
      likes: likes == freezed ? _value.likes : likes as int,
      liked: liked == freezed ? _value.liked : liked as int,
      comments: comments == freezed ? _value.comments : comments as int,
      is_live: is_live == freezed ? _value.is_live : is_live as int,
      live_ended: live_ended == freezed ? _value.live_ended : live_ended as int,
      channel_name: channel_name == freezed
          ? _value.channel_name
          : channel_name as String,
      sid: sid == freezed ? _value.sid : sid as String,
      category_id:
          category_id == freezed ? _value.category_id : category_id as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Feed implements _Feed {
  const _$_Feed(
      {this.id,
      @nullable this.image,
      @nullable this.thumbnail = '',
      @nullable this.body,
      @nullable this.date,
      @nullable this.user,
      @nullable this.likes,
      @nullable this.liked,
      @nullable this.comments,
      @nullable this.is_live,
      @nullable this.live_ended = 1,
      @nullable this.channel_name,
      @nullable this.sid,
      @nullable this.category_id});

  factory _$_Feed.fromJson(Map<String, dynamic> json) =>
      _$_$_FeedFromJson(json);

  @override
  final int id;
  @override
  @nullable
  final String image;
  @JsonKey(defaultValue: '')
  @override
  @nullable
  final String thumbnail;
  @override
  @nullable
  final String body;
  @override
  @nullable
  final String date;
  @override
  @nullable
  final User user;
  @override
  @nullable
  final int likes;
  @override
  @nullable
  final int liked;
  @override
  @nullable
  final int comments;
  @override
  @nullable
  final int is_live;
  @JsonKey(defaultValue: 1)
  @override
  @nullable
  final int live_ended;
  @override
  @nullable
  final String channel_name;
  @override
  @nullable
  final String sid;
  @override
  @nullable
  final int category_id;

  @override
  String toString() {
    return 'Feed(id: $id, image: $image, thumbnail: $thumbnail, body: $body, date: $date, user: $user, likes: $likes, liked: $liked, comments: $comments, is_live: $is_live, live_ended: $live_ended, channel_name: $channel_name, sid: $sid, category_id: $category_id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Feed &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.image, image) ||
                const DeepCollectionEquality().equals(other.image, image)) &&
            (identical(other.thumbnail, thumbnail) ||
                const DeepCollectionEquality()
                    .equals(other.thumbnail, thumbnail)) &&
            (identical(other.body, body) ||
                const DeepCollectionEquality().equals(other.body, body)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.likes, likes) ||
                const DeepCollectionEquality().equals(other.likes, likes)) &&
            (identical(other.liked, liked) ||
                const DeepCollectionEquality().equals(other.liked, liked)) &&
            (identical(other.comments, comments) ||
                const DeepCollectionEquality()
                    .equals(other.comments, comments)) &&
            (identical(other.is_live, is_live) ||
                const DeepCollectionEquality()
                    .equals(other.is_live, is_live)) &&
            (identical(other.live_ended, live_ended) ||
                const DeepCollectionEquality()
                    .equals(other.live_ended, live_ended)) &&
            (identical(other.channel_name, channel_name) ||
                const DeepCollectionEquality()
                    .equals(other.channel_name, channel_name)) &&
            (identical(other.sid, sid) ||
                const DeepCollectionEquality().equals(other.sid, sid)) &&
            (identical(other.category_id, category_id) ||
                const DeepCollectionEquality()
                    .equals(other.category_id, category_id)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(image) ^
      const DeepCollectionEquality().hash(thumbnail) ^
      const DeepCollectionEquality().hash(body) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(likes) ^
      const DeepCollectionEquality().hash(liked) ^
      const DeepCollectionEquality().hash(comments) ^
      const DeepCollectionEquality().hash(is_live) ^
      const DeepCollectionEquality().hash(live_ended) ^
      const DeepCollectionEquality().hash(channel_name) ^
      const DeepCollectionEquality().hash(sid) ^
      const DeepCollectionEquality().hash(category_id);

  @JsonKey(ignore: true)
  @override
  _$FeedCopyWith<_Feed> get copyWith =>
      __$FeedCopyWithImpl<_Feed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_FeedToJson(this);
  }
}

abstract class _Feed implements Feed {
  const factory _Feed(
      {int id,
      @nullable String image,
      @nullable String thumbnail,
      @nullable String body,
      @nullable String date,
      @nullable User user,
      @nullable int likes,
      @nullable int liked,
      @nullable int comments,
      @nullable int is_live,
      @nullable int live_ended,
      @nullable String channel_name,
      @nullable String sid,
      @nullable int category_id}) = _$_Feed;

  factory _Feed.fromJson(Map<String, dynamic> json) = _$_Feed.fromJson;

  @override
  int get id;
  @override
  @nullable
  String get image;
  @override
  @nullable
  String get thumbnail;
  @override
  @nullable
  String get body;
  @override
  @nullable
  String get date;
  @override
  @nullable
  User get user;
  @override
  @nullable
  int get likes;
  @override
  @nullable
  int get liked;
  @override
  @nullable
  int get comments;
  @override
  @nullable
  int get is_live;
  @override
  @nullable
  int get live_ended;
  @override
  @nullable
  String get channel_name;
  @override
  @nullable
  String get sid;
  @override
  @nullable
  int get category_id;
  @override
  @JsonKey(ignore: true)
  _$FeedCopyWith<_Feed> get copyWith;
}
