import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final List<Color> colorList = [
    Colors.black,
    Colors.black87,
    Colors.black38,
    Colors.black12,
  ];
  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Red FOLK Logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              height: 45,
              width: 200,
              child: FittedBox(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'FOLK Developers',
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
