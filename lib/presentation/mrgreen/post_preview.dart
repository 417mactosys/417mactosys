import 'package:flutter/material.dart';
import 'package:wilotv/domain/entities/feed.dart';
import 'package:wilotv/presentation/components/post_list_item.dart';

class PostViewer extends StatefulWidget {
  final Feed feed;
  final DC;
  PostViewer(this.DC, this.feed);
  @override
  _PostViewerState createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostListItem((){
        widget.DC();
        Navigator.of(context).pop();
      },
        feed: widget.feed, scaff: true,
      ),
    );
  }
}
