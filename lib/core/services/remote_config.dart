import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigKey {
  static const geminiApiKey = 'gemini_api_key';
}

class RemoteConfig {
  static RemoteConfig instance = RemoteConfig._();
  RemoteConfig._() {
    _configs = FirebaseRemoteConfig.instance;
    _configs.ensureInitialized();
    _configs.fetchAndActivate();
  }

  late final FirebaseRemoteConfig _configs;

  String get geminiApiKey {
    return _configs.getString(RemoteConfigKey.geminiApiKey);
  }
}
