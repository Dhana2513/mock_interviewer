import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static Analytics instance = Analytics._();

  Analytics._() {
    _analytics = FirebaseAnalytics.instance;
  }

  late final FirebaseAnalytics _analytics;

  Future<void> logErrorEvent({
    required String stacktrace,
    required String errorCode,
  }) async {
    await _analytics.logEvent(
      name: 'error_log',
      parameters: <String, Object>{
        'stacktrace': stacktrace,
        'errorCode': errorCode,
      },
    );
  }
}
