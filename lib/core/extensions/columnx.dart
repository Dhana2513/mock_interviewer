import 'package:flutter/material.dart';

abstract class ColumnX {
  static Widget builder({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
  }) {
    return Column(
      children: [
        for (int index = 0; index < itemCount; index++) itemBuilder.call(index)
      ],
    );
  }
}
