import 'package:flutter/material.dart';
// import 'package:folkEvents/customWidgets/plateform_dialog_box.dart';
// import 'package:folkEvents/helper/constants_strings.dart';

import 'package:intl/intl.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
// import 'package:url_launcher/url_launcher.dart';

class Utility {
  static const double margin16 = 16.0;

  static const double margin8 = 8.0;
  static const double margin6 = 6.0;
  static const double margin4 = 4.0;
  static const double margin10 = 10.0;

  static const String userDefaulImaga = 'assets/images/index.jpeg';

  Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double getTexfactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  String getReadableDateAndTime(int epochDate) {
    var tmp = DateTime.fromMillisecondsSinceEpoch(epochDate * 1000);
    return DateFormat.jm().addPattern('dd-MMM-yy').format(tmp);
  }

  Widget cardHeadingText({
    required String text,
    double fontSize = 20,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget cardSubHeadingText({
    required String text,
    double fontSize = 16,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
      ),
    );
  }

  String getReadableDate(int epochDate) {
    var tmp = DateTime.fromMillisecondsSinceEpoch(epochDate * 1000);
    return DateFormat('dd-MMM-yy').format(tmp);
  }

  String getDate(int epochDate) {
    var tmp = DateTime.fromMillisecondsSinceEpoch(epochDate * 1000);
    return DateFormat('dd-MMM').format(tmp);
  }

  String getTime(int epochDate) {
    var tmp = DateTime.fromMillisecondsSinceEpoch(epochDate * 1000);
    return DateFormat.jm().format(tmp);
  }

  static int get getCurrentEpoch =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Widget getTextFormField({
    required TextEditingController controller,
    required String label,
    int maxLine = 1,
    int minLine = 1,
    int? maxCharacter,
    Function(String)? callBack,
    bool editable = true,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLine,
      maxLines: maxLine,
      maxLength: maxCharacter,
      onChanged: callBack,
      enabled: editable,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        // labelText: label,
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ),
    );
  }

  Widget customRowButton({
    required BuildContext context,
    required Function yesCallBack,
    required Function noCallBack,
    required String yesLabel,
    required String noLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: getSize(context).width * 0.3,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              shadowColor: Colors.blue.shade200,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.blue),
              ),
            ),
            onPressed: () => noCallBack(),
            child: Text(
              noLabel,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: getSize(context).width * 0.3,
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
              shape: StadiumBorder(),
            ),
            onPressed: () => yesCallBack(),
            child: Text(
              yesLabel,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget centerWidget({
    required String text,
    double fontSize = 13,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: Center(
        child: Text(
          text,
          style: RobotoBoldStyle(),
        ),
      ),
    );
  }

  Widget iconButton(
      {required IconData icon,
      VoidCallback? callBack,
      Color color = Colors.grey}) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: callBack,
    );
  }

  void buildErrorSnackbar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void buildRetrySnackbar({
    required BuildContext context,
    required Function retryFunction,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Something went wrong.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            retryFunction();
          },
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  static bool checkTimeDuration(
    int startTimeEpoch, {
    int minuteInDifference = 5,
  }) {
    var startTime = DateTime.fromMillisecondsSinceEpoch(startTimeEpoch * 1000);

    return startTime
            .subtract(Duration(minutes: minuteInDifference))
            .millisecondsSinceEpoch <=
        DateTime.now().millisecondsSinceEpoch;
  }

  Future showBottomSheet({
    required BuildContext context,
    required Widget bottomPage,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  child: Icon(Icons.close),
                ),
              ),
              Divider(),
              Flexible(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: bottomPage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // static Future<void> unRegisteredUser(BuildContext context) async {
  //   final signUp = await PlatFormAlertDialogBox(
  //     title: TranslationConstants.currentLanguageData["common_alert"]!,
  //     content: 'You are not a registered Folk.',
  //     defaultActionText: 'Sign Up',
  //     // cancelActionText: 'No',
  //   ).show(context);
  //   if (signUp) {
  //     await launch(Constants.registrationLink);
  //     Navigator.pop(context);
  //   }
  // }

  String getFOLKMapLevel(String? folkLevel) {
    switch (folkLevel) {
      case "FOLK Advanced":
        return "advanced";
      case "FOLK Enhanced":
        return "enhanced";
      case "FOLK General":
        return "general";
      case "FOLK Graduate":
        return "graduate";
      case "Guide":
        return "guide";
      case "No Level":
        return "no_level";
      case "FOLK Prelims":
        return "prelims";
      case "FOLK Plus":
        return "plus";
      default:
        return "no_level";
    }
  }
}

class MyRichText extends StatelessWidget {
  final String? title, text;

  const MyRichText({Key? key, this.title, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
              text: text,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
        ],
      ),
    );
  }
}
