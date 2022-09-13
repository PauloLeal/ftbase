import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ftbase/utils/log.dart';

class LoginService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  firebase_auth.User? currentUser;

  bool isMonitoringUserStateChanges = false;

  LoginService._privateConstructor();
  static final LoginService instance = LoginService._privateConstructor();

  firebase_auth.User? get currentFirebaseUser => currentUser;

  Future<void> monitorUserState() async {
    if (isMonitoringUserStateChanges) {
      return Future.value();
    }

    isMonitoringUserStateChanges = true;

    Completer<void> c = Completer();
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebase_auth.User? user) async {
      currentUser = user;

      if (!c.isCompleted) {
        c.complete();
      }
    });

    return c.future;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;

    try {
      await FirebaseFirestore.instance.clearPersistence();
    } on Exception catch (e) {
      Log.info(e);
    }
  }
}
