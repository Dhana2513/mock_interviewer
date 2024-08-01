import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mock_interviewer/core/services/remote_config.dart';

class GenAI {
  static GenAI instance = GenAI._();
 

  GenAI._() {
    genAIModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: RemoteConfig.instance.geminiApiKey,
    );

    // final prompt = 'Write a story about a magic backpack.';
    // final content = [Content.text(prompt)];
    // final response = await model.generateContent(content);
  }

   late final GenerativeModel genAIModel;
   
}
