import 'package:cloud_functions/cloud_functions.dart';
import 'package:ftbase/utils/log.dart';

class FirebaseFunctionsService {
  final functions = FirebaseFunctions.instanceFor(region: "southamerica-east1");

  FirebaseFunctionsService._privateConstructor();
  static final FirebaseFunctionsService instance = FirebaseFunctionsService._privateConstructor();

  Future<dynamic> callFunction(String functionName, Map<String, dynamic>? params) async {
    try {
      return await functions.httpsCallable(functionName).call(params ?? {});
    } on FirebaseFunctionsException catch (error) {
      Log.error(error.code);
      Log.error(error.details);
      Log.error(error.message);
    }
  }
}
