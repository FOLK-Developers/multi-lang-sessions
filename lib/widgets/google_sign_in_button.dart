import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: OutlinedButton.icon(
          label: Text(
            'Sign In With Google',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onSurface: Colors.black,
            side: BorderSide(color: Colors.black),
            textStyle: TextStyle(color: Colors.black),
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
        ),
      );
}
