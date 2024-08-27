import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class _RemoteConfigKey {
  static const geminiApiKey = 'gemini_api_key';
  static const geminiModel = 'gemini_model';
  static const topicPrompt = 'topic_prompt';
  static const interviewPrompt = 'interview_prompt';
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
    return _configs.getString(_RemoteConfigKey.geminiApiKey);
  }

  String get geminiModel {
    return _configs.getString(_RemoteConfigKey.geminiModel);
  }

  String get topicPrompt {
    return _configs.getString(_RemoteConfigKey.topicPrompt);
  }

  String get interviewPrompt {
    return _configs.getString(_RemoteConfigKey.interviewPrompt);
  }
}
