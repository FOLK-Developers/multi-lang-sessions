import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:multi_language_sessions/custom_widgets/loading_indicator_with_text.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
import 'package:multi_language_sessions/helpers/utility.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';
import 'package:multi_language_sessions/widgets/time_picker.dart';

import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  static const routeName = '/edit-event';
  final String sessionId;

  const EditEventScreen({Key? key, this.sessionId = ''}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> updatedInfo = {};
  bool _isLoading = false;

  final TextStyle heading = RobotoBoldStyle(
    size: 17,
    weight: FontWeight.w500,
  );
  final TextStyle secondaryTextStyle = RobotoBoldStyle(
      size: 10,
      weight: FontWeight.w400,
      fontColor: Color.fromRGBO(123, 131, 138, 1));

  bool checkBoxVal = false;
  bool isLoading = true;
  late TimeOfDay selectedTime = TimeOfDay.now();
  late ThemeData themeData;
  String startTime = "";
  String endTime = "";
  String speaker = '';
  String url = '';
  String desc = '';
  String title = '';

  DateTime? selectedDate = DateTime.now();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TextEditingController startTimeCtrl = TextEditingController();
  TextEditingController endTimeCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();

  int getEpoch(DateTime date, int hour, int min) {
    return date
            .add(Duration(hours: hour, minutes: min))
            .millisecondsSinceEpoch ~/
        1000;
  }

  TimeOfDay fromEpoch(int epoch) {
    return TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(epoch * 1000));
  }

  String timeOfDayToString(TimeOfDay t) {
    String time = '';
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
    return time;
  }

  DateTime fromISOString(String date) {
    return DateTime(
      int.parse(
        date.substring(0, 4),
      ),
      int.parse(
        date.substring(5, 7),
      ),
      int.parse(
        date.substring(8, 10),
      ),
    );
  }

  _pickTime24(BuildContext context, TextEditingController? ctrl) async {
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

        ctrl!.text = timeOfDayToString(t);
        print(
            '==================\nTIME: ${ctrl.text}\n==========================');
      });
  }

  _pickDate(BuildContext context, TextEditingController? date,
      DateTime dateObj) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        dateObj = picked;
        date!.text = picked.toIso8601String().substring(0, 10);
        print(
            '==================\nDate: ${date.text}\n==========================');
      });
  }

  void setValues(Map<String, dynamic> data) {
    print('==================\nData: $data\n==========================');
    setState(() {
      data.forEach((key, value) {
        if (key == 'start_time') {
          startTimeCtrl.text = timeOfDayToString(fromEpoch(value));
          startDateCtrl.text = DateTime.fromMillisecondsSinceEpoch(value * 1000)
              .toIso8601String()
              .substring(0, 10);
        }
        if (key == 'end_time') {
          endTimeCtrl.text = timeOfDayToString(fromEpoch(value));
          endDateCtrl.text = DateTime.fromMillisecondsSinceEpoch(value * 1000)
              .toIso8601String()
              .substring(0, 10);
        }
        if (key == 'description') desc = value;
        if (key == 'video_url') url = value;
        if (key == 'speaker') speaker = value;
        if (key == 'title') title = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      FirebaseQueries().getSessionFromId(widget.sessionId).then((value) {
        updatedInfo = value!.data()!;
        setValues(updatedInfo);
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Widget _buildDatePicker(String type) {
    final themeData = Theme.of(context);
    return Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: themeData.colorScheme.primary.withAlpha(24),
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                _pickDate(
                    context,
                    type == 'Start Date' ? startDateCtrl : endDateCtrl,
                    type == 'Start Date' ? startDate : endDate);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    color: themeData.colorScheme.onPrimary,
                    size: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      type,
                      style: RobotoBoldStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          _buildTextField(
            '',
            '',
            isDate: true,
            ctrl: type == 'Start Date' ? startDateCtrl : endDateCtrl,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String type, String keyVal) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        Container(
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
              _pickTime24(
                  context, type == 'Start Time' ? startTimeCtrl : endTimeCtrl);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.watch_later,
                  color: themeData.colorScheme.onPrimary,
                  size: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(type, style: RobotoBoldStyle()),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        _buildTextField(type, keyVal,
            isTime: true,
            ctrl: type == 'Start Time' ? startTimeCtrl : endTimeCtrl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        leading: BackButton(
          color: Color.fromRGBO(0, 41, 107, 1),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        title: Text(
          'Make a Session',
          style: RobotoBoldStyle(
            weight: FontWeight.w600,
            size: 18.0,
            fontColor: Color.fromRGBO(0, 41, 107, 1),
          ),
        ),
        flexibleSpace: null,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  // width: Utility().getSize(context).width / 1.1,
                  height:
                      Utility().getSize(context).height - kToolbarHeight - 50,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          //height: Utility().getSize(context).height / 1.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Session',
                                  style: heading,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              _buildTextField('Title', 'title',
                                  initValue: title),
                              _buildTextField('Description', 'description',
                                  initValue: desc),
                              _buildTextField('Language', 'default_language',
                                  initValue: 'English'),
                              _buildTextField('Speaker', 'speaker',
                                  initValue: speaker),
                              _buildTextField('Video Link', 'video_url',
                                  initValue: url),
                              _buildTimePicker('Start Time', 'start_time'),
                              _buildTimePicker('End Time', 'end_time'),
                              _buildDatePicker('Start Date'),
                              _buildDatePicker('End Date'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          width: Utility().getSize(context).width / 1.1,
                          height: 50,
                          child: _isLoading
                              ? _loadingWidget()
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (_form.currentState!.validate()) {
                                      startDate =
                                          fromISOString(startDateCtrl.text);
                                      endDate = fromISOString(endDateCtrl.text);
                                      int startEpoch = getEpoch(
                                          startDate,
                                          int.parse(startTimeCtrl.text
                                              .substring(0, 2)),
                                          int.parse(
                                              startTimeCtrl.text.substring(5)));
                                      int endEpoch = getEpoch(
                                          endDate,
                                          int.parse(
                                              endTimeCtrl.text.substring(0, 2)),
                                          int.parse(
                                              endTimeCtrl.text.substring(5)));

                                      updatedInfo.addAll({
                                        'start_time': startEpoch,
                                        'end_time': endEpoch,
                                        'creation_time':
                                            Utility.getCurrentEpoch,
                                      });
                                      print(
                                          '======================\n Updated Info: $updatedInfo\n====================');
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: LoadingIndicatorWithMessage(
                                                    text:
                                                        'Creating your sessions..!!'),
                                              ));

                                      FirebaseQueries()
                                          .setSessionsData(updatedInfo,
                                              isUpdating: true,
                                              id: widget.sessionId)
                                          .whenComplete(() {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });

                                      //setState(() => _isLoading = false);
                                      // Navigator.of(context).pop();

                                    }
                                  },
                                  child: Text('Update Info'),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String heading, String keyValue,
      {bool isTime = false,
      TextEditingController? ctrl,
      bool isDate = false,
      String date = '',
      String initValue = ''}) {
    return Expanded(
      child: Container(
        height: 60,
        child: TextFormField(
          controller: isTime || isDate ? ctrl! : null,
          initialValue: !isTime && !isDate ? initValue : null,
          decoration: InputDecoration(
              labelText: heading,
              labelStyle: RobotoBoldStyle(weight: FontWeight.w500, size: 12),
              border: null,
              hintText: 'Type your text here',
              hintStyle: secondaryTextStyle,
              focusColor: Colors.black),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Fill the $heading field';
            } else
              return null;
          },
          onChanged: (val) {
            final data = val;
            updatedInfo.update(keyValue, (value) {
              return data;
            }, ifAbsent: () {
              return data;
            });
          },
          onFieldSubmitted: (val) {
            final data = val;
            updatedInfo.update(keyValue, (value) {
              return data;
            }, ifAbsent: () {
              return data;
            });

            print('New map: $updatedInfo');
          },
        ),
      ),
    );
  }

  _loadingWidget() {
    return SizedBox(
      height: 50,
      width: 50,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
