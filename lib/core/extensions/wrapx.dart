import 'package:flutter/material.dart';

abstract class WrapX {
  static Widget builder<T>({
    required List<T> items,
    required Widget Function(T item) itemBuilder,
  }) {
    return Wrap(
      children: [
        for (int index = 0; index < items.length; index++)
          itemBuilder.call(items[index])
      ],
    );
  }
}
