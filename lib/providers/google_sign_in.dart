import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  void loginSilently() async {
    isSigningIn = true;
    await googleSignIn.signInSilently();
    isSigningIn = false;
  }

  Future login() async {
    try {
      isSigningIn = true;
      if (await googleSignIn.isSignedIn()) {
        print('Was here');
        await googleSignIn.disconnect().whenComplete(() {
          FirebaseAuth.instance.signOut();
        });
      }
      //       final user = await googleSignIn.signIn();
      //       if (user == null) {
      //         isSigningIn = false;
      //         return;
      //       } else {
      //         final googleAuth = await user.authentication;

      //         final credential = GoogleAuthProvider.credential(
      //           accessToken: googleAuth.accessToken,
      //           idToken: googleAuth.idToken,
      //         );

      //         await FirebaseAuth.instance
      //             .signInWithCredential(credential)
      //             .then((value) {
      //           print('Cred : ${value.user}');
      //         });
      //       }
      //     });
      //   });
      //   isSigningIn = false;
      // } else {
      final user = await googleSignIn.signIn();
      if (user == null) {
        isSigningIn = false;
        return;
      } else {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          print('Cred : ${value.user}');
        });
        isSigningIn = false;
      }
    } catch (er) {
      isSigningIn = false;
      return null;
    }
  }

  void logout(BuildContext ctx) async {
    await googleSignIn.disconnect();
    Navigator.of(ctx).pop();
    FirebaseAuth.instance.signOut();
    Navigator.of(ctx).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
