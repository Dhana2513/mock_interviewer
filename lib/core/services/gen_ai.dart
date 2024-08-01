import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_interviewer/core/services/remote_config.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

class GenAI {
  static GenAI instance = GenAI._();

  GenAI._() {
    log('dddd : GenAI init');
    log('dddd : ${RemoteConfig.instance.geminiApiKey}');

    _genAIModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: RemoteConfig.instance.geminiApiKey,
    );
  }

  late final GenerativeModel _genAIModel;

  Future<String> getResponse() async {
    const prompt = 'Explain flutter architecture include images and example. format the answer as markdown';
    final content = [Content.text(prompt)];
    final response = await _genAIModel.generateContent(content);
    log('dddd : ${response.text}');
    return response.text ?? '';
  }

    Future<String> topicResponse({required Topic topic}) async {
    final prompt = 'Explain ${topic.name} include images and example. format the answer as markdown';
    
    final content = [Content.text(prompt)];
    final response = await _genAIModel.generateContent(content);
    log('dddd : ${response.text}');
    return response.text ?? '';
  }
}
