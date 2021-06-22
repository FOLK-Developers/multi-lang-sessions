import 'dart:developer' as dev;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';

import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:multi_language_sessions/screens/details_screen.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';
import 'package:multi_language_sessions/widgets/logged_in.dart';
import 'package:multi_language_sessions/widgets/signup_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Color> colorList = [
    Colors.black,
    Colors.black87,
    Colors.black38,
    Colors.black12,
  ];

  bool hasUserData = false;
  bool isLoading = false;
  String mobile = '';
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = true;
      });
      SharedPreferences.getInstance().then((value) {
        setState(() {
          hasUserData = value.getBool('user_data') != null
              ? value.getBool('user_data')!
              : false;
          mobile = value.getString('mobile') != null
              ? value.getString('mobile')!
              : '';
          isLoading = false;
        });
        print(
            '=====================\nUser data: $hasUserData\t Number: $mobile\n=============');
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: isLoading
            ? buildLoading(context)
            : ChangeNotifierProvider(
                create: (context) => GoogleSignInProvider(),
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    print('User: ${snapshot.data}');
                    final provider = Provider.of<GoogleSignInProvider>(context);

                    if (provider.isSigningIn) {
                      return buildLoading(context);
                    } else if (!snapshot.hasData && hasUserData)
                      return LoggedInWidget(null, {}, mobile);
                    else if (snapshot.hasData) {
                      final User? user = snapshot.data;
                      print('User: $user');
                      if (hasUserData)
                        return LoggedInWidget(user, {}, '');
                      else
                        return DetailsScreen(
                          hasSignedIn: true,
                          user: user,
                        );
                    } else if (snapshot.hasError) {
                      return SignUpWidget(true);
                    } else
                      return SignUpWidget(false);
                  },
                ),
              ),
      );

  Widget buildLoading(BuildContext ctx) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 213, 0, 1),
              Color.fromRGBO(255, 228, 92, 1),
              Color.fromRGBO(255, 213, 0, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Image.asset(
                //       'assets/images/Red FOLK Logo.png',
                //       height: 150,
                //       width: 150,
                //     ),
                //   ],
                // ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Signing In',
                      colors: colorList,
                      textStyle: RobotoBoldStyle(size: 20),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.zero,
              height: 80,
              width: 140,
              child: FittedBox(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'A Product of FOLK Developers',
                      colors: colorList,
                      textStyle: RobotoBoldStyle(),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
