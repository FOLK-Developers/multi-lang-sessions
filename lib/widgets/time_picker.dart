import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TimePicker extends StatefulWidget {
  final String type;
  const TimePicker({Key? key, this.type = ''}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  // _pickTime12(BuildContext context) async {
  //   TimeOfDay? t =
  //       await showTimePicker(context: context, initialTime: selectedTime);
  //   if (t != null)
  //     setState(() {
  //       selectedTime = t;
  //       showSnackbarWithFloating(t.format(context));
  //     });
  // }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late TimeOfDay selectedTime = TimeOfDay.now();
  late ThemeData themeData;

  _pickTime24(BuildContext context) async {
    TimeOfDay? t = await showTimePicker(
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        context: context,
        initialTime: selectedTime);
    if (t != null)
      setState(() {
        selectedTime = t;
        String time = "";
        if (t.hour < 10) {
          time = time + "0" + t.hour.toString();
        } else {
          time = time + t.hour.toString();
        }
        time = time + " : ";
        if (t.minute < 10) {
          time = time + "0" + t.minute.toString();
        } else {
          time = time + t.minute.toString();
        }
        print('==================\nTIME: $time\n==========================');
        //showSnackbarWithFloating(time);
      });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: themeData.colorScheme.primary.withAlpha(28),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _pickTime24(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.watch_later,
                color: themeData.colorScheme.onPrimary,
                size: 22,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.type, style: RobotoBoldStyle()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
