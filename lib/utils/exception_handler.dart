part of ftbase;

enum AuthProblems { UserNotFound, PasswordNotValid, NetworkError, AppProblem }

class ExceptionHandler {
  static void handle(dynamic e) {
    if (e is FirebaseAuthException) {
      return handleFirebaseException(e);
    } else if (e is FlutterError) {
      Log.info(e.toString());
    } else {
      Log.info(e.toString());
    }
  }

  static void handleFirebaseException(FirebaseAuthException e) {
    Log.info("throwing new error - ${e.code}");

    AuthProblems errorType = AuthProblems.AppProblem;

    switch (e.code) {
      case 'Error 17011':
        errorType = AuthProblems.UserNotFound;
        break;
      case 'Error 17009':
        errorType = AuthProblems.PasswordNotValid;
        break;
      case 'Error 17020':
        errorType = AuthProblems.NetworkError;
        break;
      // ...
      default:
        Log.info('Case ${e.message} is not yet implemented');
    }

    Log.info("[${errorType.toString()}] ${e.message} is not yet implemented");
    // }

    // if (Platform.isAndroid) {
    //   switch (e.message) {
    //     case 'There is no user record corresponding to this identifier. The user may have been deleted.':
    //       errorType = authProblems.UserNotFound;
    //       break;
    //     case 'The password is invalid or the user does not have a password.':
    //       errorType = authProblems.PasswordNotValid;
    //       break;
    //     case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
    //       errorType = authProblems.NetworkError;
    //       break;
    //     // ...
    //     default:
    //       Log.info('Case ${e.message} is not yet implemented');
    //   }
    // } else if (Platform.isIOS) {
    //   switch (e.code) {
    //     case 'Error 17011':
    //       errorType = authProblems.UserNotFound;
    //       break;
    //     case 'Error 17009':
    //       errorType = authProblems.PasswordNotValid;
    //       break;
    //     case 'Error 17020':
    //       errorType = authProblems.NetworkError;
    //       break;
    //     // ...
    //     default:
    //       Log.info('Case ${e.message} is not yet implemented');
    //   }
    // // }
  }
}
