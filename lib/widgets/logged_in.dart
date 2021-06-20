//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:multi_language_sessions/providers/google_sign_in.dart';
// import 'package:multi_language_sessions/widgets/video_list.dart';

import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

class LoggedInWidget extends StatefulWidget {
  static const routeName = '/logged-in';
  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: yt.YoutubePlayer.convertUrlToId(
          'https://www.youtube.com/watch?v=Ut85dWwrTV8')!,
      params: const YoutubePlayerParams(
        playlist: [
          'nPt8bK2gbaU',
          'K18cpp_-gP8',
          'iLnmTe5Q2Qw',
          '_WoCV4c6XOE',
          'KmzdUe0RSJo',
          '6jZDSSZZxjQ',
          'p2lYr3vM_1w',
          '7QUtEmBT_-w',
          '34_PXCzGw1M',
        ],
        startAt: const Duration(minutes: 1, seconds: 36),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: true,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      print('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      print('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Youtube Player IFrame'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: player),
                  const SizedBox(
                    width: 500,
                    child: SingleChildScrollView(
                      child: Controls(),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              children: [
                player,
                const Controls(),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          // MetaDataSection(),
          // _space,
          // SourceInputSection(),
          // _space,
          // PlayPauseButtonBar(),
          // _space,
          // VolumeSlider(),
          // _space,
          // PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}