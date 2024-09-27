import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mock_interviewer/core/extensions/string_extension.dart';
import 'package:mock_interviewer/core/services/local_storage.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

import '../../shared/models/question.dart';

abstract class _FirestoreKey {
  static const topics = 'topics_';
  static const questions = 'questions_';
  static const videos = 'videos_';
}

class Firestore {
  static Firestore instance = Firestore._();

  Firestore._() {
    _firestore = FirebaseFirestore.instance;

    _topics = _firestore
        .collection(_FirestoreKey.topics + LocalStorage.instance.userName);

    _questions = _firestore
        .collection(_FirestoreKey.questions + LocalStorage.instance.userName);
  }

  late final FirebaseFirestore _firestore;
  late final CollectionReference _topics;
  late final CollectionReference _questions;

  final topicStream = StreamController<List<Topic>>();
  final List<Topic> topics = [];

  void allTopics() {
    _topics.snapshots().listen((snapshot) {
      topics.clear();
      topics.addAll(snapshot.docs
          .map((doc) => Topic.fromJson(
              documentID: doc.id, json: doc.data() as Map<String, dynamic>))
          .toList());

      topicStream.sink.add(topics);
    });
  }

  Future<String> addTopic(Topic topic) async {
    final doc = await _topics.add(topic.toJson());
    return doc.id;
  }

  Future<void> deleteTopic(Topic topic) async {
    await _topics.doc(topic.documentID).delete();
  }

  Future<String> addQuestions({
    required String fileName,
    required List<Question> questions,
  }) async {
    final json = questions.map((question) => question.toJson()).toList();

    final doc = await _questions.add({
      fileName: json,
      'userName': LocalStorage.instance.userName,
    });

    return doc.id;
  }

  Future<(String, List<Question>)> fetchQuestions(String fileName) async {
    final result = await _questions.get();
    List<Question> questions = [];
    String userName = '';

    for (var doc in result.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(fileName)) {
        questions = Question.fromJsonList(jsonList: data[fileName]);
        userName = data['userName'] ?? '';
        userName = userName.replaceAll('@gmail.com', '').sentenceCase;
      }
    }

    return (userName, questions);
  }

  void dispose() {
    topicStream.close();
  }
}
