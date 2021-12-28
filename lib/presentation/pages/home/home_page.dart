import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import '../../../application/feed/feed_bloc.dart';
import '../../../domain/entities/feed.dart';
import '../../../infrastructure/api/api_service.dart';
import '../../../injection.dart';
import '../../components/no_internet.dart';
import '../../components/post_list_item.dart';
import '../../components/post_list_shimmer.dart';
import '../../mrgreen/suggestions.dart';
import 'widgets/categories.dart';

class HomePage extends StatefulWidget {
  static _HomePageState state;

  @override
  _HomePageState createState() {
    state = _HomePageState();
    return state;
  }
}

class Live {
  String username;
  String image;
  int channelId;
  bool me;

  Live({this.username, this.me, this.image, this.channelId});
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = ScrollController();
  FeedBloc _feedBloc;

  List<Feed> _feeds = [];
  int _offset = 0;
  bool _hasReachedEndOfResults = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initScrollListener();

    // dbChangeListen();
  }

  Future<bool> refresh() {
    _feeds.clear();
    _offset = 0;
    _hasReachedEndOfResults = false;
    _feedBloc.add(FeedEvent.getUserFeeds(_offset));
    _loading = true;
    return Future.value(true);
  }

  getFeeds() {
    _feeds.clear();
    _offset = 0;
    _feedBloc.add(FeedEvent.getUserFeeds(_offset));
    _loading = true;
  }

  // List<Live> list = [];
  // Live liveUser;
  // final databaseReference = Firestore.instance;

  // void dbChangeListen() {
  //   databaseReference
  //       .collection('liveuser')
  //       .orderBy("time", descending: true)
  //       .snapshots()
  //       .listen((result) {
  //
  //     list = [];
  //     result.documents.forEach((result) {
  //       list.add(Live(username: '',image: '',channelId: 0 ,me: false));
  //     });
  //     setState(() {
  //
  //     });
  //   });
  // }

  void _initScrollListener() {
    _scrollController
      ..addListener(() {
        var triggerFetchMoreSize =
            0.9 * _scrollController.position.maxScrollExtent;

        if (!_loading &&
            !_hasReachedEndOfResults &&
            _scrollController.position.pixels > triggerFetchMoreSize) {
          context.bloc<FeedBloc>().add(FeedEvent.getUserFeeds(_offset));
          _loading = true;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refresh,
      child: BlocProvider(
        create: (context) =>
            _feedBloc = getIt<FeedBloc>()..add(FeedEvent.getUserFeeds(_offset)),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return state.userFeedsFailureOrSuccess.fold(
              () => PostListShimmer(),
              (either) => either.fold(
                (failure) => NoInternet(
                  msg: failure.map(
                    serverError: (_) => null,
                    apiFailure: (e) => e.msg,
                  ),
                  onPressed: refresh,
                ),
                (success) => success.feeds == null
                    ? 0
                    : success.feeds.isEmpty ||
                            success.feeds.first.id == null ||
                            success.feeds.length == 0
                        // ? _noFeeds()

                        ? StreamBuilder(
                            stream:
                                HeyPApiService.create().getFeeds(0).asStream(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              print('TRENDING POSTS');
                              print(snapshot.data.body.feeds);
                              final List<dynamic> feeds = List();
                              feeds.addAll(snapshot.data.body.feeds);
                              sug = 0;
                              while (sug < feeds.length) {
                                sug = sug + 8;
                                if (sug < feeds.length)
                                  feeds.insert(sug, 'Suggest');
                              }
                              return InViewNotifierList(
                                // controller: _scrollController,
                                // physics: BouncingScrollPhysics(),
                                // shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),

                                // shrinkWrap: true,
                                //      separatorBuilder: (context, index) => SizedBox(
                                //        height: 10,
                                //      ),
                                isInViewPortCondition: (double deltaTop,
                                    double deltaBottom,
                                    double viewPortDimension) {
                                  return deltaTop <
                                          (0.55 * viewPortDimension) &&
                                      deltaBottom > (0.55 * viewPortDimension);
                                },
                                itemCount: 0,
                                builder: (context, index) {
                                  if (index == 0) {
                                    return Categories([Live()]);
                                  }
                                  if (index == 1) {
                                    return Suggestions();
                                  }

                                  if (index == 2) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 6,
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(16),
                                          child: Text(
                                            'Suggested Posts',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  if (feeds[index - 3] is Feed) {
                                    return PostListItem(() {
                                      setState(() {
                                        feeds.remove(feeds[index - 3]);
                                      });
                                    },
                                        feed: feeds[index - 3],
                                        index: index - 3,
                                        scaff: false);
                                  } else {
                                    return Suggestions();
                                  }
                                },
                              );
                              // return Container();
                            },
                          )
                        : _feedsList(success.feeds),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _noFeeds() {
  //   return Column(
  //     children: [
  //       Suggestions(),
  //       NoPostsWidget(
  //           onPressed: refresh,
  //           //icon: 'no_result',
  //           //message: 'no_results_try_to_add_posts_and_follow_users'.tr(),
  //           message:
  //           'When you follow people, you\'ll see the photos and videos they post here.',
  //           title: 'Welcome to Pixalive'),
  //       SizedBox(
  //         height: 24,
  //       ),
  //     ],
  //   );
  // }
  //Explore posts api

  int sug = 0;
//   enum Suggest {
//     User
// }
  Widget _feedsList(List<dynamic> feed) {
    sug = 0;

    List<dynamic> feeds = List();

    feeds.addAll(feed);

    while (sug < feeds.length) {
      sug = sug + 8;
      if (sug < feeds.length) feeds.insert(sug, 'Suggest');
    }

    if (feed.length < 8) {
      //feeds.add('Suggest');
    }

    print('IS_COMING');

    feeds.forEach((element) {
      print(element);
    });

    return InViewNotifierList(
      controller: _scrollController,
      // physics: BouncingScrollPhysics(),
      // shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),

      // shrinkWrap: true,
//      separatorBuilder: (context, index) => SizedBox(
//        height: 10,
//      ),
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) {
        return deltaTop < (0.55 * viewPortDimension) &&
            deltaBottom > (0.55 * viewPortDimension);
      },
      itemCount: feeds.length + 1,
      builder: (context, index) {
        if (index == 0) {
          return Categories([Live()]);
          return InViewNotifierWidget(
              id: '293i24',
              builder: (BuildContext context, bool isInView, Widget child) {
                return Categories([Live()]);
              });
        }
        if (feeds[index - 1] is Feed) {
          return PostListItem(() {
            setState(() {
              feeds.remove(feeds[index - 1]);
            });
          }, feed: feeds[index - 1], index: index - 1, scaff: false);
        } else {
          return Suggestions();
          return InViewNotifierWidget(
              id: '293i24768',
              builder: (BuildContext context, bool isInView, Widget child) {
                return Suggestions();
              });
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
