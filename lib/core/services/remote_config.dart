import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigKeys {
  static const geminiApiKey = 'gemini_api_key';
}

class RemoteConfig {
  static RemoteConfig instance = RemoteConfig._();
  RemoteConfig._();

  String get geminiApiKey {
    return FirebaseRemoteConfig.instance
        .getString(RemoteConfigKeys.geminiApiKey);
  }
}
