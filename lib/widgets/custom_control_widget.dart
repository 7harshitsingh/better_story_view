import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;

  const CustomControlsWidget({
    Key? key,
    this.controller,
    this.onControlsVisibilityChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.controller!.isVideoInitialized()!
          ? SizedBox.shrink()
          : const SizedBox(
              height: 48,
              width: 48,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
