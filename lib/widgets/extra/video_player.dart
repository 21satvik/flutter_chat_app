import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayer extends StatefulWidget {
  final String Url;

  VideoPlayer(this.Url);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.Url);
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePlayPause: true,
            enableMute: false,
            enableOverflowMenu: false,
            enableSkips: false,
            showControlsOnInitialize: false,
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _betterPlayerController!,
      ),
    );
  }
}
