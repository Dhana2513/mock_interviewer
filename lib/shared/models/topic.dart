import 'package:flutter/material.dart';
import '../../core/constants/asset_images.dart';

part '../types/topic_type.dart';

abstract class TopicKey {
  static const name = 'name';
  static const topicType = 'topicType';

  static const description = 'description';
  static const dart = 'dart';
  static const flutter = 'flutter';
  static const other = 'other';
}

class Topic {
  final String name;
  final TopicType topicType;
  String? documentID;
  String? description;

  Topic({
    required this.name,
    required this.topicType,
    this.documentID,
    this.description,
  });

  factory Topic.fromJson({
    required String documentID,
    required Map<String, dynamic> json,
  }) {
    return Topic(
      documentID: documentID,
      name: json[TopicKey.name],
      topicType: TopicTypeX.fromString(json[TopicKey.topicType]),
      description: json[TopicKey.description],
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      TopicKey.name: name,
      TopicKey.topicType: topicType.name,
      TopicKey.description: description,
    };
  }
}
