abstract class _QuestionKey {
  static const topic = 'topic';
  static const question = 'question';
}

class Question {
  final String topic;
  final String question;

  Question({required this.topic, required this.question});

  factory Question.fromJson({required Map<String, dynamic> json}) {
    return Question(
      topic: json[_QuestionKey.topic],
      question: json[_QuestionKey.question],
    );
  }

  static List<Question> fromJsonList({
    required List<Map<String, dynamic>> json,
  }) {
    return json.map((item) => Question.fromJson(json: item)).toList();
  }
}
