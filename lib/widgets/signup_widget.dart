import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/background_painter.dart';
import 'package:multi_language_sessions/screens/details_screen.dart';
import 'package:multi_language_sessions/widgets/google_sign_in_button.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: BackgroundPainter(),
          ),
          buildSignUp(context),
        ],
      );

  Widget _detailsButton(BuildContext context) {
    return OutlinedButton(
      child: Text(
        'Enter your details',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onSurface: Colors.black,
        side: BorderSide(color: Colors.black),
        textStyle: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(DetailsScreen.routeName);
      },
    );
  }

  Widget buildSignUp(BuildContext ctx) => Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 175,
              child: Text(
                'Welcome To The Hare Krishna App',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          GoogleSignupButtonWidget(),
          SizedBox(height: 12),
          _detailsButton(ctx),
          Text(
            'Login to continue',
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
        ],
      );
}
