import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/columnx.dart';
import 'package:mock_interviewer/core/services/firestore.dart';
import 'package:mock_interviewer/features/study/add_topic.dart';
import 'package:mock_interviewer/features/study/topic_description_screen.dart';
import 'package:mock_interviewer/shared/models/topic.dart';

import '../../core/constants/text_style.dart';
import '../../core/extensions/ui_navigator.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Firestore.instance.allTopics();
  }

  Widget get addTopicButton => Positioned(
        bottom: BoxPadding.basic,
        right: BoxPadding.basic,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BoxPadding.medium),
                  ),
                  child: const AddTopic(),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      );

  void showDeleteAlert({required Topic topic}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${Constants.delete} ${topic.name}?'),
          content: Text('${Constants.deleteAlertText} ${topic.name}?'),
          actions: [
            TextButton(
              child: const Text(Constants.delete),
              onPressed: () async {
                Navigator.of(context).pop();
                Firestore.instance.deleteTopic(topic);
              },
            ),
            TextButton(
              child: const Text(Constants.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(BoxPadding.basic),
              child: Text(Constants.topics, style: UITextStyle.title),
            ),
            StreamBuilder<List<Topic>>(
                stream: Firestore.instance.topicStream.stream,
                builder: (context, snapshot) {
                  final unfilteredTopics = snapshot.data ?? [];
                  final otherTopics = unfilteredTopics
                      .where((topic) => topic.topicType == TopicType.other);

                  final dartTopics = unfilteredTopics
                      .where((topic) => topic.topicType == TopicType.dart);

                  final flutterTopics = unfilteredTopics
                      .where((topic) => topic.topicType == TopicType.flutter);

                  final topics = [
                    ...otherTopics,
                    ...dartTopics,
                    ...flutterTopics
                  ];

                  if (topics.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(BoxPadding.basic),
                        child: Text(
                          Constants.noTopicsMessage,
                          style: UITextStyle.bodyLarge,
                        ),
                      ),
                    );
                  }

                  return ColumnX.builder(
                      itemCount: topics.length,
                      itemBuilder: (index) {
                        final topic = topics[index];

                        return Card(
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: BoxPadding.small),
                            child: ListTile(
                              onTap: () {
                                UINavigator.push(
                                  context: context,
                                  screen: TopicDescriptionScreen(
                                    topics: topics,
                                    index: index,
                                  ),
                                );
                              },
                              tileColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(BoxPadding.small))),
                              leading: Image(
                                image: topic.topicType.image,
                                width: BoxPadding.xLarge,
                                height: BoxPadding.xLarge,
                              ),
                              title: Text(
                                topic.name,
                                style: UITextStyle.subtitle,
                              ),
                              trailing: IconButton(
                                icon: Padding(
                                  padding:
                                      const EdgeInsets.all(BoxPadding.xSmall),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                onPressed: () => showDeleteAlert(topic: topic),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
        addTopicButton,
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    Firestore.instance.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
