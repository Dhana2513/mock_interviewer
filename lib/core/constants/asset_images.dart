import 'package:flutter/material.dart';

class AssetImages {
  static AssetImages shared = AssetImages._();
  AssetImages._();

  AssetImage flutter = const AssetImage('assets/icons/flutter.png');
  AssetImage dart = const AssetImage('assets/icons/dart.png');
  AssetImage curly = const AssetImage('assets/icons/curly.png');

}
