import 'package:flutter/material.dart';
import '../../core/constants/asset_images.dart';

part '../types/topic_type.dart';

abstract class _TopicKey {
  static const name = 'name';
  static const topicType = 'topicType';

  static const description = 'description';
}

class Topic {
  final String name;
  final TopicType topicType;
  String? documentID;
  String? description;
  bool? selected;

  Topic({
    required this.name,
    required this.topicType,
    this.documentID,
    this.description,
    this.selected,
  });

  factory Topic.fromJson({
    required String documentID,
    required Map<String, dynamic> json,
  }) {
    return Topic(
      documentID: documentID,
      name: json[_TopicKey.name],
      topicType: TopicTypeX.fromString(json[_TopicKey.topicType]),
      description: json[_TopicKey.description],
    );
  }

  Topic copyWith({
    String? name,
    TopicType? topicType,
    String? documentID,
    String? description,
    bool? selected,
  }) {
    return Topic(
      name: name ?? this.name,
      topicType: topicType ?? this.topicType,
      documentID: documentID ?? this.documentID,
      description: description ?? this.description,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      _TopicKey.name: name,
      _TopicKey.topicType: topicType.name,
      _TopicKey.description: description,
    };
  }
}
