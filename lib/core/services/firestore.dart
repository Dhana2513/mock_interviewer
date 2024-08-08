import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

abstract class FirestoreKey {
  static const topics = 'topics';
}

class Firestore {
  static Firestore instance = Firestore._();

  Firestore._() {
    _firestore = FirebaseFirestore.instance;

    _topics = _firestore.collection(FirestoreKey.topics);
  }

  late final FirebaseFirestore _firestore;
  late final CollectionReference _topics;
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

  void dispose() {
    topicStream.close();
  }
}
