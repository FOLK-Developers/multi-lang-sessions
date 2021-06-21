import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';

import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:multi_language_sessions/widgets/logged_in.dart';
import 'package:multi_language_sessions/widgets/signup_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final List<Color> colorList = [
    Colors.black,
    Colors.black87,
    Colors.black38,
    Colors.black12,
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading(context);
              } else if (snapshot.hasData) {
                //check if details are in database
                return LoggedInWidget();
              } else {
                return SignUpWidget(false);
              }
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
                      textStyle: RobotoBoldStyle(),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.zero,
              height: 45,
              width: MediaQuery.of(ctx).size.width - 20,
              child: FittedBox(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'A Product of FOLK Developers',
                      colors: colorList,
                      textStyle: RobotoBoldStyle(size: 12),
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
