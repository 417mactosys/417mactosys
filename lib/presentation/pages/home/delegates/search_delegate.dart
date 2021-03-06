import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilotv/presentation/mrgreen/searchUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import '../../../mrgreen/searchUser.dart';

import '../../../../application/search/search_bloc.dart';
import '../../../../domain/entities/feed.dart';
import '../../../../infrastructure/core/pref_manager.dart';
import '../../../../injection.dart';
import '../../../components/highlight_text_widget.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';
import '../../search/search_page.dart';

class PostSearch extends SearchDelegate<Feed> {
  SearchBloc _bloc = getIt<SearchBloc>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      backgroundColor: kColorPrimary,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    FocusScope.of(context).unfocus();
    _bloc = getIt<SearchBloc>();
    return SearchPage(
      query: query,
      showAppBar: false,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_bloc != null) {
      _bloc.add(SearchEvent.queryChanged(query));
      _bloc.add(SearchEvent.search());
    }
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.searchPostsFailureOrSuccessOption.fold(
            () => Center(
              child: query.isEmpty
                  ? Text('type_something'.tr())
                  : CircularProgressIndicator(),
            ),
            (either) => either.fold(
              (failure) => Container(),
              (success) => success.feeds.isEmpty
                  ? _noResultsWidget()
                  : _resultsWidget(context, success.feeds),
            ),
          );
        },
      ),
    );
  }

  Widget _noResultsWidget() {
    return Center(
      child: Text(
        'no_results'.tr(),
      ),
    );
  }

  Widget _resultsWidget(BuildContext context, List<Feed> feeds) {
    return StreamBuilder(
        stream: http
            .get(
              'https://wilotv.live:3443/api/search?query=$query',
            )
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Center(
              child: Text('Loading'),
            );
          print('SNAPSHOT DATA');
          var user = jsonDecode(snapshot.data.body)['feeds'] as List;
          print(user[0]);

          return ListView.builder(
            itemCount: user.length,
            itemBuilder: (context, index) {
              return SearchUser(user[index], query);
            },
          );
        });
  }
}
