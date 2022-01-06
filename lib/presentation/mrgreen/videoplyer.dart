import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  String url;
  bool autoply;
  CustomVideoPlayer(this.url, {this.autoply = true});
  @override
  CustomVideoPlayerState createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.url,
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true));
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            fit: BoxFit.contain,
            autoPlay: false,
            looping: false,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                backgroundColor: Colors.black,
                showControls: true,
                controlBarColor: Colors.black,
                controlsHideTime: Duration(milliseconds: 500),
                skipForwardIcon: Icons.skip_next_rounded,
                skipBackIcon: Icons.skip_previous_rounded,
                enableSkips: false,
                enableSubtitles: false,
                enableAudioTracks: false,
                enablePlayPause: true,
                enableProgressText: false,
                enableQualities: false,
                playIcon: Icons.play_arrow_rounded,
                forwardSkipTimeInMilliseconds: 5000,
                backwardSkipTimeInMilliseconds: 5000,

                // enableProgressText: true,
                progressBarHandleColor: Colors.red,
                progressBarPlayedColor: Colors.red)),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}
