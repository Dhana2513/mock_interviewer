part of '../models/topic.dart';

enum TopicType { dart, flutter, kotlin, android, other }

extension TopicTypeX on TopicType {
  static TopicType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'dart':
        return TopicType.dart;
      case 'flutter':
        return TopicType.flutter;
      case 'kotlin':
        return TopicType.kotlin;
      case 'android':
        return TopicType.android;
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
      case TopicType.kotlin:
        return 'Kotlin';
      case TopicType.android:
        return 'Android';
      default:
        return 'Other';
    }
  }

  String get promptInitials {
    switch (this) {
      case TopicType.dart:
        return 'Dart: ';
      case TopicType.flutter:
        return 'Flutter: ';
      case TopicType.kotlin:
        return 'Kotlin: ';
      case TopicType.android:
        return 'Android: ';
      default:
        return '';
    }
  }

  AssetImage get image {
    switch (this) {
      case TopicType.dart:
        return AssetImages.shared.dart;

      case TopicType.flutter:
        return AssetImages.shared.flutter;

      case TopicType.kotlin:
        return AssetImages.shared.kotlin;

      case TopicType.android:
        return AssetImages.shared.android;

      default:
        return AssetImages.shared.curly;
    }
  }
}
