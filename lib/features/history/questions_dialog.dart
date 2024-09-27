import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';
import 'package:mock_interviewer/core/constants/text_style.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/shared/models/question.dart';

class QuestionsDialog extends StatelessWidget {
  const QuestionsDialog({
    super.key,
    required this.questions,
  });

  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Padding(
      padding: const EdgeInsets.all(BoxPadding.basic),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(BoxPadding.small),
            child: Text(Constants.questions, style: UITextStyle.title),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: questions.map((question) {
              index++;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Q$index: ${question.question}',
                  style: UITextStyle.body.copyWith(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
