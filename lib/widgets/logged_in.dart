//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:multi_language_sessions/custom_widgets/loading_indicator_with_text.dart';
import 'package:multi_language_sessions/helpers/utility.dart';
import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:multi_language_sessions/screens/events_list_screen.dart';
import 'package:multi_language_sessions/screens/make_event_screen.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';
import 'package:multi_language_sessions/widgets/meta_data_section.dart';
// import 'package:multi_language_sessions/providers/google_sign_in.dart';
// import 'package:multi_language_sessions/widgets/video_list.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

import 'play_pause_bar.dart';
import 'source_input_section.dart';

class LoggedInWidget extends StatefulWidget {
  static const routeName = '/logged-in';
  final User? user;
  final Map<String, dynamic> userData;
  final String mobile;

  LoggedInWidget(this.user, this.userData, this.mobile);
  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget>
    with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool? status;
  bool isLoading = true;
  bool noSessions = false;
  String role = '';
  bool toggleFullScreen = false;
  DocumentSnapshot? sessionDoc;
  DocumentSnapshot? userDoc;
  List<int> sessionTrack = [Utility.getCurrentEpoch];
  Timer? _timer;
  Timer? _refreshTimer;
  Map<String, dynamic> finalUserData = {};

  AppLifecycleState _notification = AppLifecycleState.resumed;

  void createAttendanceMap(
      Map<String, dynamic> initMap, Map<String, dynamic> data) {
    return initMap.addAll(data);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    setState(() {
      _notification = state;
    });
  }

  Future<void> getSessionAndMarkAttendance(
      Map<String, dynamic> finalUserData) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseQueries().getCurrentSession().then(
      (value) {
        print('VALUE : $value');
        setState(() => sessionDoc = value);
      },
    ).whenComplete(() {
      if (sessionDoc != null) {
        createAttendanceMap(finalUserData, {
          'session_id': sessionDoc!.id,
          'user_doc_id': userDoc!.id,
          'start_time': sessionDoc!.get('start_time'),
          'end_time': sessionDoc!.get('end_time'),
          'duration':
              sessionDoc!.get('end_time') - sessionDoc!.get('start_time'),
          'date': Utility().getReadableDate(sessionDoc!.get('start_time')),
          'session_track': sessionTrack,
        });
        FirebaseQueries().markAttendance(
            userDocId: userDoc!.id,
            sessionId: sessionDoc!.id,
            data: finalUserData,
            sessionTrack: sessionTrack);
        print('===========');
        print('URL : ${sessionDoc!.get('video_url')!}');
        print('===========');
        _controller = YoutubePlayerController(
          initialVideoId:
              yt.YoutubePlayer.convertUrlToId(sessionDoc!.get('video_url'))!,
          params: const YoutubePlayerParams(
            //startAt: const Duration(minutes: 1, seconds: 36),
            showControls: true,
            showFullscreenButton: false,
            desktopMode: true,
            privacyEnhanced: true,
            useHybridComposition: true,
          ),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          noSessions = true;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('================INIT STATE================');
    finalUserData = widget.userData;
    WidgetsBinding.instance!.addObserver(this);

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = true;
      });
      Future.sync(() async {
        FirebaseQueries()
            .getUserData(
                widget.user == null ? widget.mobile : widget.user!.email!,
                isMobile: widget.user == null ? true : false)
            .then((value) {
          finalUserData = value!.data();
          userDoc = value;
          print('===========');
          print('INITIAL DATA : $finalUserData');
          print('===========');

          if (widget.user != null || finalUserData['gmail'] != '')
            FirebaseQueries()
                .checkAdminStatus(widget.user == null
                    ? finalUserData['gmail']
                    : widget.user!.email!)
                .then((value) {
              if (value.size > 0)
                setState(() {
                  role = value.docs.first.data()['role'][0];
                });
              print('===========');
              print('\t\t\t\tRole : $role');
            });
        }).whenComplete(() async {
          await FirebaseQueries().getCurrentSession().then(
            (value) {
              print('VALUE : $value');
              setState(() => sessionDoc = value);
            },
          ).whenComplete(() {
            if (sessionDoc != null) {
              createAttendanceMap(finalUserData, {
                'session_id': sessionDoc!.id,
                'user_doc_id': userDoc!.id,
                'start_time': sessionDoc!.get('start_time'),
                'end_time': sessionDoc!.get('end_time'),
                'duration':
                    sessionDoc!.get('end_time') - sessionDoc!.get('start_time'),
                'date':
                    Utility().getReadableDate(sessionDoc!.get('start_time')),
                'session_track': sessionTrack,
              });
              FirebaseQueries().markAttendance(
                  userDocId: userDoc!.id,
                  sessionId: sessionDoc!.id,
                  data: finalUserData,
                  sessionTrack: sessionTrack);
              print('===========');
              print('URL : ${sessionDoc!.get('video_url')!}');
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
              setState(() {
                isLoading = false;
              });
            } else {
              setState(() {
                noSessions = true;
                isLoading = false;
              });
            }
          });
        });
      });
    });
  }

  Widget textContainer(String text) {
    return Container(
      child: Text(text),
    );
  }

  PreferredSizeWidget myAppbar() {
    return AppBar(
      title: const Text('Gita Sessions'),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) => Dialog(
                      child: LoadingIndicatorWithMessage(text: 'Logging Out !'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ));
            SharedPreferences.getInstance()
                .then((value) => value.clear())
                .whenComplete(() {
              if (widget.user != null)
                Provider.of<GoogleSignInProvider>(context, listen: false)
                    .logout(context);

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            });
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildEventAdminPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(MakeEventScreen.routeName);
          },
          child: Container(
            height: 70,
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(EventsListScreen.routeName);
          },
          child: Container(
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today),
                const SizedBox(
                  width: 70,
                ),
                Text('Edit Event'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget myDrawer() {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.user == null
                ? finalUserData['photo_url'] == ''
                    ? null
                    : finalUserData['photo_url']
                : '${widget.user!.photoURL!}'),
          ),
          const SizedBox(
            height: 20,
          ),
          textContainer(widget.user == null
              ? finalUserData['name']
              : widget.user!.displayName!),
          if (role == 'event_admin') _buildEventAdminPanel(),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      print('=====================\nDOC : $sessionDoc\n=================');

      if (sessionDoc != null) {
        print(
            '=====================\nLeft : ${Utility().getTime(sessionDoc!.get('end_time'))}  - ${Utility().getTime(Utility.getCurrentEpoch)}  = ${sessionDoc!.get('end_time') - Utility.getCurrentEpoch} \n=================');
        _refreshTimer = Timer.periodic(
            Duration(
                seconds: sessionDoc!.get('end_time') - Utility.getCurrentEpoch),
            (timer) {
          getSessionAndMarkAttendance(finalUserData);
        });
        if (_notification == AppLifecycleState.resumed)
          _timer = Timer.periodic(Duration(minutes: 1), (timer) {
            sessionTrack.add(Utility.getCurrentEpoch);
            FirebaseQueries().markAttendance(
                userDocId: userDoc!.id,
                sessionId: sessionDoc!.id,
                data: {},
                sessionTrack: sessionTrack);
            print(
                '=====================\nADDED : $sessionTrack\n=================');
          });
        else
          _timer!.cancel();
      } else if (_refreshTimer != null) _refreshTimer!.cancel();

      const player = YoutubePlayerIFrame();

      return noSessions
          ? Scaffold(
              appBar: myAppbar(),
              drawer: myDrawer(),
              body: Center(
                child: Text(
                    'No Sessions at the moment.. :)\nPlease come back later.'),
              ),
            )
          : YoutubePlayerControllerProvider(
              // Passing controller to widgets below.

              controller: _controller,
              child: Scaffold(
                drawer: myDrawer(),
                appBar: myAppbar(),
                body: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : player,
              ),
            );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
