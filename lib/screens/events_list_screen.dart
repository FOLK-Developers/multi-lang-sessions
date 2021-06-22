import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
import 'package:multi_language_sessions/screens/edit_events_screen.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';

class EventsListScreen extends StatefulWidget {
  static const routeName = '/events-list';
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>?>> _list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      FirebaseQueries().getAllSession().then((value) {
        setState(() {
          _list = value!;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditEventScreen(
                      sessionId: _list[index].reference.id,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeData.colorScheme.secondary,
                  child: Text(
                    index.toString(),
                    style: themeData.textTheme.bodyText1!
                        .copyWith(color: themeData.colorScheme.onSecondary),
                  ),
                ),
                title: Text(
                  _list[index].get('title').toString(),
                  style: RobotoBoldStyle(),
                ),
                subtitle: Text(
                  _list[index].get('description'),
                ),
                trailing:
                    Text('Speaker : ${_list[index].get('speaker').toString()}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
