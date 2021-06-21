import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/background_painter.dart';
import 'package:multi_language_sessions/screens/details_screen.dart';
import 'package:multi_language_sessions/widgets/google_sign_in_button.dart';

class SignUpWidget extends StatelessWidget {
  final bool hasError;
  SignUpWidget(this.hasError);

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.loose,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: BackgroundPainter(),
          ),
          Image.asset(
            'assets/images/folk_logo.png',
            height: 150,
            width: 150,
          ),
          buildSignUp(context),
        ],
      );

  Widget _detailsButton(BuildContext context) {
    return OutlinedButton(
      child: Text(
        'Enter your details',
        style: TextStyle(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onSurface: Colors.black,
        side: BorderSide(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(DetailsScreen.routeName);
      },
    );
  }

  Widget buildSignUp(BuildContext ctx) => Center(
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome to Gita Sessions',
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
            Text('OR'),
            SizedBox(height: 12),
            _detailsButton(ctx),
            Spacer(),
          ],
        ),
      );
}
