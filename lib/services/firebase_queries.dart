import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_language_sessions/helpers/utility.dart';

class FirebaseQueries with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<QuerySnapshot<Map<String, dynamic>>> checkAdminStatus(
      String email) async {
    log('\\\\\\\\\\\\\\\\\\\\');
    log('Email : $email');
    log('\\\\\\\\\\\\\\');
    final data =
        await _db.collection('Admin').where('gmail', isEqualTo: email).get();

    return data;
  }

  void setUserData(Map<String, dynamic> data) {
    _db.collection('Users').add(data);
  }

  Future<void> setSessionsData(Map<String, dynamic> data) async {
    await _db.collection('Sessions').add(data);
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> getUserData(
      String gmail) async {
    return await _db
        .collection('Users')
        .where('gmail', isEqualTo: gmail)
        .get()
        .then((value) {
      return value.docs.first;
    });
  }

  Future<DocumentSnapshot?> checkNumberExists(String mobile) async {
    try {
      print('===================\n Mobile: $mobile\n=================');
      return await _db
          .collection('Users')
          .where('number', isEqualTo: mobile)
          .get()
          .then((val) {
        print('=====================\n\n SNAP : ${val.docs.first.data()}');
        return val.docs.first;
      });
    } catch (er) {
      return null;
    }
  }

  Future<DocumentSnapshot?> getCurrentSession() async {
    //end time > current time
    //sort by start time
    //show the first feed
    try {
      return await _db
          .collection('Sessions')
          .where('end_time', isGreaterThan: Utility.getCurrentEpoch)
          .orderBy(
            'end_time',
          )
          .get()
          .then((val) {
        print('=====================\n\n SNAP : ${val.docs.first.data()}');
        return val.docs.first;
      });
    } catch (er) {
      print('=====================\n\n SNAP : $er\n===================');
      return null;
    }
  }

  void markAttendance(
      {required String userDocId,
      required String sessionId,
      required Map<String, dynamic> data,
      required List<int> sessionTrack}) {
    try {
      print('===========');
      print('DATA : $data');
      print('===========');
      final attendanceCollection =
          _db.collection('Users').doc(userDocId).collection('Attendance');

      attendanceCollection.get().then((value) {
        final length = value.docs.length;
        _db.collection('Users').doc(userDocId).update({'sessions': length});

        if (length > 0) {
          print('===========');
          print('Session ID : $sessionId');
          print('===========');
          attendanceCollection
              .where('session_id', isEqualTo: sessionId)
              .get()
              .then((value) {
            value.docs.first.reference.update({
              'session_track': sessionTrack,
            });
          }).whenComplete(() {
            print('==========\nUPDATED\n==============');
          });
        } else
          attendanceCollection.add(data).whenComplete(() {
            print('==========\nADDED\n==============');
          });
      });
    } catch (er) {
      print('==========\nERROR: $er\n==============');
    }
  }
}
