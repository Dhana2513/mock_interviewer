class Topic {
  final String name;
  final TopicType topicType;

  Topic({required this.name, required this.topicType});
}

enum TopicType { dart, flutter, other }

typedef TopicCallback = void Function({required Topic topic});
