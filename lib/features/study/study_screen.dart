import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/services/gen_ai.dart';
import 'package:mock_interviewer/features/study/add_topic.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  @override
  void initState() {
    super.initState();
    GenAI.instance.getResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: BoxPadding.basic,
          right: BoxPadding.basic,
          child: FloatingActionButton(
            onPressed: () async {
              final topic = await showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const AddTopic(),
                  );
                },
              );

              if (topic != null) {
                GenAI.instance.topicResponse(topic: topic);
              }
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
