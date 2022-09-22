part of ftbase;

class FirebaseAnalyticsService {
  FirebaseAnalyticsService._privateConstructor();
  static final FirebaseAnalyticsService instance = FirebaseAnalyticsService._privateConstructor();

  Future<void> logAppOpen({AnalyticsCallOptions? callOptions}) async {
    await FirebaseAnalytics.instance.logAppOpen(callOptions: callOptions);
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {
    await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters, callOptions: callOptions);
  }
}
