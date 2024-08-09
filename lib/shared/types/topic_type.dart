part of '../models/topic.dart';

enum TopicType { dart, flutter, other }

extension TopicTypeX on TopicType {
  static TopicType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'dart':
        return TopicType.dart;
      case 'flutter':
        return TopicType.flutter;
      default:
        return TopicType.other;
    }
  }

  String get stringValue {
    switch (this) {
      case TopicType.dart:
        return 'Dart';
      case TopicType.flutter:
        return 'Flutter';
      default:
        return 'Other';
    }
  }

  AssetImage get image {
    switch (this) {
      case TopicType.dart:
        return AssetImages.shared.dart;

      case TopicType.flutter:
        return AssetImages.shared.flutter;

      default:
        return AssetImages.shared.curly;
    }
  }
}
