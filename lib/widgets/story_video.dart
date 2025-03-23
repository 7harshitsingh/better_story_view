import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:story_view/widgets/custom_control_widget.dart';
import '../controller/story_controller.dart';

class StoryVideo extends StatefulWidget {
  final StoryController? storyController;
  final String httpurl;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  StoryVideo(
    this.httpurl, {
    Key? key,
    this.storyController,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key ?? UniqueKey());

  static StoryVideo url(
    String url, {
    StoryController? controller,
    Map<String, dynamic>? requestHeaders,
    Key? key,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return StoryVideo(
      url,
      key: key,
      storyController: controller,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return StoryVideoState();
  }
}

class StoryVideoState extends State<StoryVideo> {
  StreamSubscription? _streamSubscription;
  // VideoPlayerController? playerController;

  BetterPlayerController? _betterPlayerController;

  Future<void> _initializePlayer() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.httpurl,
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      headers: {
        "Range": "bytes=0-",
      },
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 9 / 16,
        autoPlay: true,
        looping: true,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (controller, onControlsVisibilityChanged) =>
              CustomControlsWidget(
            controller: controller,
            onControlsVisibilityChanged: onControlsVisibilityChanged,
          ),
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void initState() {
    super.initState();

    widget.storyController!.pause();
    _initializePlayer().then((value) {
      setState(() {});
      widget.storyController!.play();
    });

    if (widget.storyController != null) {
      _streamSubscription =
          widget.storyController!.playbackNotifier.listen((playbackState) {
        if (playbackState == PlaybackState.pause) {
          _betterPlayerController!.pause();
        } else {
          _betterPlayerController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: BetterPlayer(controller: _betterPlayerController!),
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
