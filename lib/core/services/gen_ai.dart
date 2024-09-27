import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_interviewer/core/services/remote_config.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

import 'analytics.dart';

class GenAI {
  static GenAI instance = GenAI._();

  GenAI._() {
    _genAIModel = GenerativeModel(
      model: RemoteConfig.instance.geminiModel,
      apiKey: RemoteConfig.instance.geminiApiKey,
    );
  }

  late final GenerativeModel _genAIModel;

  Future<String> topicResponse({required Topic topic}) async {
    try {
      final initText = topic.topicType.promptInitials;

      final prompt = RemoteConfig.instance.topicPrompt
          .replaceAll('<<topicName>>', '$initText${topic.name}');

      final content = [Content.text(prompt)];
      final response = await _genAIModel.generateContent(content);

      return response.text ?? '';
    } on Exception catch (error) {
      log(error.toString());
      Analytics.instance.logErrorEvent(stacktrace: '$error', errorCode: '101');
      return '';
    }
  }

  Future<List> getQuestions({required List<Topic> topics}) async {
    try {
      final topicNames = topics.map((topic) => topic.name).toList();

      final prompt = RemoteConfig.instance.interviewPrompt
          .replaceAll('<<topicList>>', '$topicNames');

      final content = [Content.text(prompt)];
      final response = await _genAIModel.generateContent(
        content,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      return jsonDecode(response.text ?? '[]');
    } on Exception catch (error) {
      Analytics.instance.logErrorEvent(stacktrace: '$error', errorCode: '102');
      return [];
    }
  }
}
