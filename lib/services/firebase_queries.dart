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

  Future<DocumentSnapshot?> getCurrentSession() async {
    //end time > current time
    //sort by start time
    //show the first feed
    try {
      return await _db
          .collection('Sessions')
          .where('end_time', isGreaterThan: Utility.getCurrentEpoch)
          .orderBy('end_time', descending: true)
          .get()
          .then((val) {
        print('=====================\n\n SNAP : ${val.docs.first.data()}');
        return val.docs.first;
      });
    } catch (er) {
      return null;
    }
  }

  void markAttendance(
      {required String userDocId,
      required String sessionId,
      required Map<String, dynamic> data,
      required List<int> sessionTrack}) {
    final attendanceCollection =
        _db.collection('Users').doc(userDocId).collection('Attendance');
    attendanceCollection.snapshots().length.then((value) {
      if (value > 0) {
        attendanceCollection
          ..where('session_id', isEqualTo: sessionId).get().then((value) {
            value.docs.first
                .data()
                .update('session_track', (value) => value = sessionTrack);
          });
      } else
        attendanceCollection.add(data);
    });
  }
}
