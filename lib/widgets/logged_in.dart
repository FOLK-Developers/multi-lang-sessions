//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:multi_language_sessions/custom_widgets/loading_indicator_with_text.dart';
import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:multi_language_sessions/screens/make_event_screen.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';
import 'package:multi_language_sessions/widgets/meta_data_section.dart';
// import 'package:multi_language_sessions/providers/google_sign_in.dart';
// import 'package:multi_language_sessions/widgets/video_list.dart';

import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

import 'play_pause_bar.dart';
import 'source_input_section.dart';

class LoggedInWidget extends StatefulWidget {
  static const routeName = '/logged-in';
  final User? user;
  final Map<String, dynamic> userData;

  LoggedInWidget(this.user, this.userData);
  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  late YoutubePlayerController _controller;
  bool? status;
  bool isLoading = false;
  bool noSessions = false;
  String role = '';
  bool toggleFullScreen = false;
  DocumentSnapshot? sessionDoc;
  DocumentSnapshot? userDoc;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> finalUserData = widget.userData;

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = true;
      });
      Future.sync(() async {
        if (finalUserData.isEmpty) {
          FirebaseQueries().getUserData(widget.user!.email!).then((value) {
            finalUserData = value.data();
            userDoc = value;
          });
        }
        await FirebaseQueries()
            .checkAdminStatus(widget.user!.email!)
            .then((value) {
          if (value.size > 0)
            setState(() {
              role = value.docs.first.data()['role'][0];
            });
          print('===========');
          print('\t\t\t\tRole : $role');
        });
        await FirebaseQueries()
            .getCurrentSession()
            .then(
              (value) => setState(() => sessionDoc = value),
            )
            .whenComplete(() {
          if (sessionDoc != null) {
            FirebaseQueries().markAttendance(
                userDocId: userDoc!.id,
                sessionId: sessionDoc!.id,
                data: finalUserData,
                sessionTrack: [0]);
            print('===========');
            print('\t\t\t\tURL : ${sessionDoc!.get('video_url')!}');
            print('===========');
            _controller = YoutubePlayerController(
              initialVideoId: yt.YoutubePlayer.convertUrlToId(
                  sessionDoc!.get('video_url'))!,
              params: const YoutubePlayerParams(
                //startAt: const Duration(minutes: 1, seconds: 36),
                showControls: true,
                showFullscreenButton: false,
                desktopMode: true,
                privacyEnhanced: true,
                useHybridComposition: true,
              ),
            );
          } else {
            setState(() {
              noSessions = true;
            });
          }

          setState(() {
            isLoading = false;
          });
        });
      });
    });

    // _controller = YoutubePlayerController(
    //   initialVideoId: yt.YoutubePlayer.convertUrlToId(
    //       'https://www.youtube.com/watch?v=Ut85dWwrTV8')!,
    //   params: const YoutubePlayerParams(
    //     playlist: [
    //       'GLHAcAkdB8M',
    //       'K18cpp_-gP8',
    //       'iLnmTe5Q2Qw',
    //       '_WoCV4c6XOE',
    //       'KmzdUe0RSJo',
    //       '6jZDSSZZxjQ',
    //       'p2lYr3vM_1w',
    //       '7QUtEmBT_-w',
    //       '34_PXCzGw1M',
    //     ],
    //     startAt: const Duration(minutes: 1, seconds: 36),
    //     showControls: true,
    //     showFullscreenButton: false,
    //     desktopMode: true,
    //     privacyEnhanced: true,
    //     useHybridComposition: true,
    //   ),
    // );
    // _controller.onEnterFullscreen = () {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ]);
    //   print('Entered Fullscreen');
    // };
    // _controller.onExitFullscreen = () {
    //   print('Exited Fullscreen');
    // };
  }

  Widget textContainer(String text) {
    return Expanded(
      flex: 2,
      child: Container(
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('=====================\nDOC : $sessionDoc\n=================');
    const player = YoutubePlayerIFrame();
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : noSessions
            ? Scaffold(
                body: Center(
                  child: Text(
                      'No Sessions at the moment.. :)\nPlease come back later.'),
                ),
              )
            : YoutubePlayerControllerProvider(
                // Passing controller to widgets below.
                controller: _controller,
                child: Scaffold(
                  drawer: Drawer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(widget.user!.photoURL ==
                                  null
                              ? 'https://www.pngkey.com/png/full/282-2820067_taste-testing-at-baskin-robbins-empty-profile-picture.png'
                              : '${widget.user!.photoURL!}'),
                        ),
                        textContainer(widget.user!.displayName!),
                        if (role == 'event_admin')
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(MakeEventScreen.routeName);
                            },
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today),
                                  const SizedBox(
                                    width: 70,
                                  ),
                                  Text('Add Event'),
                                ],
                              ),
                            ),
                          ),
                        Spacer(),
                      ],
                    ),
                  ),
                  appBar: !toggleFullScreen
                      ? AppBar(
                          title: const Text('Gita Sessions'),
                          actions: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => Dialog(
                                          child: LoadingIndicatorWithMessage(
                                              text: 'Logging Out !'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ));

                                Provider.of<GoogleSignInProvider>(context,
                                        listen: false)
                                    .logout(context);
                              },
                              icon: Icon(Icons.logout),
                            ),
                          ],
                        )
                      : null,
                  // body: LayoutBuilder(
                  //   builder: (context, constraints) {
                  //     if (constraints.maxWidth > 800) {
                  //       return Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Expanded(child: player),
                  //           const SizedBox(
                  //             width: 500,
                  //             child: SingleChildScrollView(
                  //               child: Controls(),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     }
                  //     return ListView(
                  //       children: [
                  //         player,
                  //         //const Controls(),
                  //       ],
                  //     );
                  //   },
                  // ),
                  body: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : player,
                ),
              );
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
