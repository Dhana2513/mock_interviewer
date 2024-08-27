import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/text_style.dart';

class UIButton extends StatelessWidget {
  const UIButton({super.key, required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      onPressed: onPressed,
      child: Text(
        title,
        style: UITextStyle.subtitle.copyWith(color: Colors.white),
      ),
    );
  }
}
