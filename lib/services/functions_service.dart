import 'package:cloud_functions/cloud_functions.dart';
import 'package:ftbase/utils/log.dart';

class FunctionsService {
  final functions = FirebaseFunctions.instanceFor(region: "southamerica-east1");

  FunctionsService._privateConstructor();
  static final FunctionsService instance = FunctionsService._privateConstructor();

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
