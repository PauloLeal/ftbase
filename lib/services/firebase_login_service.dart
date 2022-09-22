part of ftbase;

enum LoginResponse { SUCCEEDED, FAILED, VERIFIED }

class FirebaseLoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _lastVerificationId;
  PhoneAuthCredential? _verifiedCredential;
  User? _currentUser;

  bool isMonitoringUserStateChanges = false;

  FirebaseLoginService._privateConstructor();
  static final FirebaseLoginService instance = FirebaseLoginService._privateConstructor();

  User? get currentFirebaseUser => _currentUser;

  Future<void> initialize() async {
    if (isMonitoringUserStateChanges) {
      return Future.value();
    }

    isMonitoringUserStateChanges = true;

    Completer<void> c = Completer();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
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

  Future<void> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    _currentUser = credential.user;
  }

  bool isSignedInAnonymously() {
    if (_currentUser == null) {
      return false;
    }

    return _currentUser?.providerData.isEmpty == true;
  }

  Future<LoginResponse> sendPhoneToken(String phoneNumber, Duration timeout, void Function() onVerificationTimeout) async {
    Completer<LoginResponse> c = Completer();

    _verifiedCredential = null;

    await _auth.verifyPhoneNumber(
      timeout: timeout,
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        // await _auth.signInWithCredential(credential); //disabled
        _verifiedCredential = credential;
        c.complete(LoginResponse.VERIFIED);
      },
      verificationFailed: (FirebaseAuthException e) {
        Log.error(e);
        c.complete(LoginResponse.FAILED);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _lastVerificationId = verificationId;
        c.complete(LoginResponse.SUCCEEDED);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onVerificationTimeout();
      },
    );

    return c.future;
  }

  Future<void> verifyPhoneNumberAndSignIn(String? code) async {
    PhoneAuthCredential credential;

    if (code != null) {
      credential = PhoneAuthProvider.credential(
        verificationId: _lastVerificationId!,
        smsCode: code,
      );
    } else if (_verifiedCredential != null) {
      credential = _verifiedCredential!;
    } else {
      return;
    }

    await _auth.signInWithCredential(credential);

    await Future.doWhile(() async {
      return await Future.delayed(
          const Duration(milliseconds: 200), () => FirebaseLoginService.instance.currentFirebaseUser == null);
    });
  }
}
