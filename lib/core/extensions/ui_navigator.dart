import 'package:flutter/material.dart';

abstract class UINavigator {
  static Future<T?> push<T extends Object?>({
    required BuildContext context,
    required Widget screen,
  }) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
