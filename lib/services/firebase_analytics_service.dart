import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  FirebaseAnalyticsService._privateConstructor();
  static final FirebaseAnalyticsService instance = FirebaseAnalyticsService._privateConstructor();

  Future<void> setUseId(String idUser) async {
    await FirebaseAnalytics.instance.setUserId(id: idUser);
  }

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

  FirebaseAnalyticsObserver routeObserver() => FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
}
