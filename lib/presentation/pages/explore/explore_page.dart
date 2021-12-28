import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';
import 'package:wilotv/presentation/components/post_exploregrid_item.dart';
import 'package:wilotv/presentation/components/post_gridFooter.dart';
import 'package:wilotv/presentation/components/post_grid_item.dart';
import 'package:wilotv/presentation/routes/routes.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import 'package:wilotv/presentation/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../../application/feed/feed_bloc.dart';
import '../../../domain/entities/feed.dart';
import '../../../injection.dart';
import '../../components/no_internet.dart';
import '../../components/no_posts_widget.dart';
import '../../components/post_list_item.dart';
import '../../components/post_list_shimmer.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin<ExplorePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = ScrollController();
  FeedBloc _feedBloc;

  List<Feed> _feeds = [];
  int _offset = 0;
  bool _hasReachedEndOfResults = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initScrollListener();
  }

  Future<bool> _refresh() {
    _feeds.clear();
    _offset = 0;
    _hasReachedEndOfResults = false;
    _feedBloc.add(FeedEvent.getFeeds(_offset));
    _loading = true;
    return Future.value(true);
  }

  void _initScrollListener() {
    _scrollController
      ..addListener(() async {
        var triggerFetchMoreSize =
            0.9 * _scrollController.position.maxScrollExtent;

        //print('SCFROLLING');
        if (!_loading &&
            !_hasReachedEndOfResults &&
            _scrollController.position.pixels > triggerFetchMoreSize) {
          print('LOAD MORE');
          _feedBloc.add(FeedEvent.getFeeds(++_offset));
          _loading = false;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: BlocProvider(
        create: (context) =>
        _feedBloc = getIt<FeedBloc>()..add(FeedEvent.getFeeds(_offset)),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return state.allFeedsFailureOrSuccess.fold(
              //() => PostListShimmer(),
                  () {
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).primaryColor,
                  highlightColor: Colors.grey[100],
                  child: StaggeredGridView.countBuilder(
                    //controller: _scrollController,
                    crossAxisCount: 3,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    physics: BouncingScrollPhysics(),
                    itemCount: 30,
                    itemBuilder: (BuildContext context, int index) => Container(
                      //margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                        Prefs.isDark() ? Color(0xff121212) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey,
                        //     offset: Offset(0.0, 1.0), //(x,y)
                        //     blurRadius: 1.0,
                        //   ),
                        // ],
                      ),
                    ),
                    staggeredTileBuilder: (int index) {
                      int remain = index % 18;
                      if (remain == 1 || remain == 9) {
                        return StaggeredTile.count(2, 2);
                      }
                      return StaggeredTile.count(1, 1);
                    },
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                );
              },
                  (either) => either.fold(
                    (failure) => NoInternet(
                  msg: failure.map(
                    serverError: (_) => null,
                    apiFailure: (e) => e.msg,
                  ),
                  onPressed: _refresh,
                ),
                    (success) => success.feeds.isEmpty
                    ? _noFeeds()
                    : _feedsList(success.feeds),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _noFeeds() {
    return NoPostsWidget(
      onPressed: _refresh,
      message: 'no_posts_so_far_try_again_later'.tr(),
      title: 'No Posts',
    );
  }

  Widget _feedsList(List<Feed> feeds) {
    List<Feed> t = [];
    feeds.forEach((element) {
      if (element.image != '') {
        t.add(element);
        print('FEED LIST');
        print(element);
      }
    });
    // setState(() {});
    return StaggeredGridView.countBuilder(
      controller: _scrollController,
      crossAxisCount: 3,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      itemCount: t.length,
      itemBuilder: (BuildContext context, int index) {
        int remain = index % 18;
        var isBig = false;
        if (remain == 1 || remain == 9) {
          isBig = true;
        }
        //  print(t[index].image + "IMAGE EXPLORE");
        if (t[index].image != '')
          return PostExploreGridItem(feed: t[index], big: isBig);

        return Container(
          color: Colors.red,
        );
      },
      staggeredTileBuilder: (int index) {
        int remain = index % 18;
        if (remain == 1 || remain == 9) {
          return StaggeredTile.count(2, 2);
        }
        return StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
