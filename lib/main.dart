import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_language_sessions/providers/country_code_provider.dart';
import 'package:multi_language_sessions/providers/google_sign_in.dart';
import 'package:multi_language_sessions/screens/details_screen.dart';

import 'package:multi_language_sessions/screens/home_page.dart';
import 'package:multi_language_sessions/widgets/logged_in.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryCodeProvider>(
          create: (context) => CountryCodeProvider(),
        ),
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
      ],
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return MaterialApp(
                title: 'Multi Language Sessions',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: HomePage(),
                routes: {
                  DetailsScreen.routeName: (context) => DetailsScreen(),
                  LoggedInWidget.routeName: (context) => LoggedInWidget()
                },
              );
            else
              return CircularProgressIndicator();
          }),
    );
  }
}
