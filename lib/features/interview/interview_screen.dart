import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/columnx.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';

import '../../core/extensions/wrapx.dart';
import '../../core/services/firestore.dart';
import '../../shared/models/topic.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with AutomaticKeepAliveClientMixin {
  final List<List<Topic>> allTopics = [];
  final List<Topic> selectedTopics = [];

  @override
  void initState() {
    super.initState();

    List<Topic> listByTopicType(TopicType type) {
      return Firestore.instance.topics
          .where((tp) => tp.topicType == type)
          .toList();
    }

    allTopics.add(listByTopicType(TopicType.other));
    allTopics.add(listByTopicType(TopicType.dart));
    allTopics.add(listByTopicType(TopicType.flutter));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(BoxPadding.basic),
      child: ListView(
        children: [
          ColumnX.builder(
              itemCount: allTopics.length,
              itemBuilder: (index) {
                final topics = allTopics[index];

                if (topics.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Text(topics.first.topicType.stringValue),
                    const SizedBox(height: BoxPadding.basic),
                    WrapX.builder<Topic>(
                      items: topics,
                      itemBuilder: (topic) {
                        return Chip(label:Text( topic.name));
                      },
                    ),
                  ],
                );
              }),
          UIButton(
            onPressed: () {},
            title: Constants.startInterview,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
