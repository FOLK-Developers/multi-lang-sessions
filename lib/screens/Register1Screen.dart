// import 'package:multi_language_sessions/custom_widgets/MyCol.dart';
// import 'package:multi_language_sessions/custom_widgets/MyRow.dart';


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:multi_language_sessions/custom_widgets/ScreenMedia.dart';
// import 'package:provider/provider.dart';

// import '../../AppNotifier.dart';
// import '../../AppTheme.dart';


// class FoodRegisterScreen extends StatefulWidget {
//   @override
//   _FoodRegisterScreenState createState() => _FoodRegisterScreenState();
// }

// class _FoodRegisterScreenState extends State<FoodRegisterScreen> {
//   ThemeData themeData;
//   CustomAppTheme customAppTheme;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppNotifier>(
//       builder: (BuildContext context, AppNotifier value, Widget child) {
//         int themeType = value.themeMode();
//         themeData = AppTheme.getThemeFromThemeMode(themeType);
//         customAppTheme = AppTheme.getCustomAppTheme(themeType);


//         return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
//             home: Scaffold(
//                 backgroundColor: customAppTheme.bgLayer1,
//                 body: Container(
//                   margin: Spacing.x(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       MyRow(
//                         wrapAlignment: WrapAlignment.center,
//                         children: [
//                           MyCol(
//                             flex: {
//                               ScreenMediaType.SM: 16,
//                               ScreenMediaType.MD: 12,
//                               ScreenMediaType.XL: 10,
//                               ScreenMediaType.XXL: 8,
//                               ScreenMediaType.XXXL: 6,
//                             },
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Container(
//                                   child: Image.asset(
//                                     './assets/icons/food-outline.png',
//                                     color: themeData.colorScheme.primary,
//                                     width: 36,
//                                     height: 36,
//                                   ),
//                                 ),
//                                 Spacing.height(24),
//                                 Text(
//                                   "Create account".toUpperCase(),
//                                   style: AppTheme.getTextStyle(
//                                       themeData.textTheme.headline6,
//                                       color: themeData.colorScheme.onBackground,
//                                       fontWeight: 700,
//                                       letterSpacing: 0.5),
//                                 ),
//                                 Spacing.height(24),
//                                 MyContainer.bordered(
//                                   paddingAll:12,
//                                   color: customAppTheme.bgLayer2,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         padding: Spacing.all(6),
//                                         decoration: BoxDecoration(
//                                             color:
//                                             themeData.colorScheme.primary,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(8))),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                               8),
//                                           child: Icon(
//                                             MdiIcons.accountOutline,
//                                             color:
//                                             themeData.colorScheme.onPrimary,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           margin: Spacing.left(16),
//                                           child: TextFormField(
//                                             style: AppTheme.getTextStyle(
//                                                 themeData.textTheme.bodyText1,
//                                                 letterSpacing: 0.1,
//                                                 color: themeData
//                                                     .colorScheme.onBackground,
//                                                 fontWeight: 500),
//                                             decoration: InputDecoration(
//                                               hintText: "Name",
//                                               hintStyle: AppTheme.getTextStyle(
//                                                   themeData.textTheme.subtitle2,
//                                                   letterSpacing: 0.1,
//                                                   color: themeData
//                                                       .colorScheme.onBackground,
//                                                   fontWeight: 500),
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               isDense: true,
//                                               contentPadding: EdgeInsets.all(0),
//                                             ),
//                                             textCapitalization:
//                                             TextCapitalization.sentences,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Spacing.height(16),
//                                 MyContainer.bordered(
//                                   paddingAll:12,
//                                   color: customAppTheme.bgLayer2,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         padding: Spacing.all(6),
//                                         decoration: BoxDecoration(
//                                             color:
//                                             themeData.colorScheme.primary,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(8))),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: Icon(
//                                             MdiIcons.emailOutline,
//                                             color:
//                                             themeData.colorScheme.onPrimary,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           margin: Spacing.left(16),
//                                           child: TextFormField(
//                                             style: AppTheme.getTextStyle(
//                                                 themeData.textTheme.bodyText1,
//                                                 letterSpacing: 0.1,
//                                                 color: themeData
//                                                     .colorScheme.onBackground,
//                                                 fontWeight: 500),
//                                             decoration: InputDecoration(
//                                               hintText: "Email Address",
//                                               hintStyle: AppTheme.getTextStyle(
//                                                   themeData.textTheme.subtitle2,
//                                                   letterSpacing: 0.1,
//                                                   color: themeData
//                                                       .colorScheme.onBackground,
//                                                   fontWeight: 500),
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               isDense: true,
//                                               contentPadding: EdgeInsets.all(0),
//                                             ),
//                                             textCapitalization:
//                                             TextCapitalization.sentences,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Spacing.height(16),
//                                 MyContainer.bordered(
//                                   paddingAll:12,
//                                   color: customAppTheme.bgLayer2,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         padding: Spacing.all(6),
//                                         decoration: BoxDecoration(
//                                             color:
//                                             themeData.colorScheme.primary,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(8))),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: Icon(
//                                             MdiIcons.lockOutline,
//                                             color:
//                                             themeData.colorScheme.onPrimary,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           margin: Spacing.left(16),
//                                           child: TextFormField(
//                                             style: AppTheme.getTextStyle(
//                                                 themeData.textTheme.bodyText1,
//                                                 letterSpacing: 0.1,
//                                                 color: themeData
//                                                     .colorScheme.onBackground,
//                                                 fontWeight: 500),
//                                             decoration: InputDecoration(
//                                               hintText: "Password",
//                                               hintStyle: AppTheme.getTextStyle(
//                                                   themeData.textTheme.subtitle2,
//                                                   letterSpacing: 0.1,
//                                                   color: themeData
//                                                       .colorScheme.onBackground,
//                                                   fontWeight: 500),
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                   borderSide: BorderSide.none),
//                                               isDense: true,
//                                               contentPadding: EdgeInsets.all(0),
//                                             ),
//                                             keyboardType: TextInputType.text,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Spacing.height(16),

//                                 ElevatedButton(
//                                   style: ButtonStyle(
//                                       padding: MaterialStateProperty.all(Spacing.xy(32, 0))
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 FoodFullApp()));
//                                   },
//                                   child: Text(
//                                     "Register".toUpperCase(),
//                                     style: AppTheme.getTextStyle(
//                                         themeData.textTheme.bodyText2,
//                                         fontWeight: 600,
//                                         color: themeData.colorScheme.onPrimary,
//                                         letterSpacing: 0.5),
//                                   ),

//                                 ),
//                                 Spacing.height(16),
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 FoodLoginScreen()));
//                                   },
//                                   child: Text(
//                                     "I have already an account",
//                                     style: AppTheme.getTextStyle(
//                                         themeData.textTheme.bodyText2,
//                                         color: themeData.colorScheme.onBackground,
//                                         fontWeight: 500,
//                                         decoration: TextDecoration.underline),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 )));
//       },
//     );
//   }

// }
