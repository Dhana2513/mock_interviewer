import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_interviewer/core/services/remote_config.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

class GenAI {
  static GenAI instance = GenAI._();

  GenAI._() {
    _genAIModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: RemoteConfig.instance.geminiApiKey,
    );
  }

  late final GenerativeModel _genAIModel;

  Future<String> topicResponse({required Topic topic}) async {
    log('dddd :added topic prompt');

    final prompt =
        'Explain ${topic.name} include images and example. format the answer as markdown';

    final content = [Content.text(prompt)];
    final response = await _genAIModel.generateContent(content);
    log('dddd : topic response');
    return response.text ?? '';
  }
}
