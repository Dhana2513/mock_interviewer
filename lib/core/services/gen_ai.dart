import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_interviewer/core/services/remote_config.dart';
import 'package:mock_interviewer/shared/models/topic.dart';
import 'package:mock_interviewer/shared/types/topic_type.dart';

class GenAI {
  static GenAI instance = GenAI._();

  GenAI._() {
    log('dddd:  genAI : apiKey: ${RemoteConfig.instance.geminiApiKey}');
    _genAIModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: RemoteConfig.instance.geminiApiKey,
    );
  }

  late final GenerativeModel _genAIModel;

  Future<String> topicResponse({required Topic topic}) async {
    final initText = topic.topicType == TopicType.dart
        ? 'dart: '
        : topic.topicType == TopicType.flutter
            ? 'flutter: '
            : '';

    final prompt =
        'Explain $initText${topic.name} in detail, include images and example. format the answer as markdown';

    log('dddd :added prompt : $prompt');

    final content = [Content.text(prompt)];
    final response = await _genAIModel.generateContent(content);

    log('dddd : topic response : ${response.text}');
    return response.text ?? '';
  }
}
