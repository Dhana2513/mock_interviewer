import 'package:flutter/material.dart';

import '../../core/constants/asset_images.dart';

enum TopicType { dart, flutter, other }

extension TopicTypeX on TopicType {
  static TopicType fromString(String type) {
    switch (type) {
      case 'dart':
        return TopicType.dart;
      case 'flutter':
        return TopicType.flutter;
      default:
        return TopicType.other;
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
