part of ftbase;

class FirebaseService {
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  Future<void> initializeApp() async {
    await Firebase.initializeApp();
  }
}
