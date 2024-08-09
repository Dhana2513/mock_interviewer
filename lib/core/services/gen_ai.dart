import 'dart:convert';

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
    try {
      final initText = topic.topicType == TopicType.dart
          ? 'dart: '
          : topic.topicType == TopicType.flutter
              ? 'flutter: '
              : '';

      final prompt = RemoteConfig.instance.topicPrompt
          .replaceAll('<<topicName>>', '$initText${topic.name}');

      final content = [Content.text(prompt)];
      final response = await _genAIModel.generateContent(content);

      return response.text ?? '';
    } on Exception catch (_) {
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
    } on Exception catch (_) {
      return [];
    }
  }
}
