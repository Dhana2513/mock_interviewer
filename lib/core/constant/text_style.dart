import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/extensions/text_size.dart';

abstract class UITextStyle {
  static const title = TextStyle(
    fontSize: TextSize.large,
    fontWeight: FontWeight.w500,
  );

  static const subtitle = TextStyle(
    fontSize: TextSize.large - 2.0,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(
    fontSize: TextSize.basic,
    fontWeight: FontWeight.w400,
  );

  static const bodyLarge = TextStyle(
    fontSize: TextSize.large,
    fontWeight: FontWeight.w400,
  );
}
