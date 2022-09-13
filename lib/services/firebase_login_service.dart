import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ftbase/utils/log.dart';

class FirebaseLoginService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  firebase_auth.User? _currentUser;

  bool isMonitoringUserStateChanges = false;

  FirebaseLoginService._privateConstructor();
  static final FirebaseLoginService instance = FirebaseLoginService._privateConstructor();

  firebase_auth.User? get currentFirebaseUser => _currentUser;

  Future<void> monitorUserState() async {
    if (isMonitoringUserStateChanges) {
      return Future.value();
    }

    isMonitoringUserStateChanges = true;

    Completer<void> c = Completer();
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) async {
      _currentUser = user;

      if (!c.isCompleted) {
        c.complete();
      }
    });

    return c.future;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;

    try {
      await FirebaseFirestore.instance.clearPersistence();
    } on Exception catch (e) {
      Log.info(e);
    }
  }
}
