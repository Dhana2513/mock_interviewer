import 'package:flutter/material.dart';

class AssetImages {
  static AssetImages shared = AssetImages._();

  AssetImages._();

  AssetImage appIcon = const AssetImage('assets/icons/interview.png');

  AssetImage flutter = const AssetImage('assets/icons/flutter.png');
  AssetImage dart = const AssetImage('assets/icons/dart.png');
  AssetImage curly = const AssetImage('assets/icons/curly.png');
  AssetImage kotlin = const AssetImage('assets/icons/kotlin.png');
  AssetImage android = const AssetImage('assets/icons/android.png');
}
