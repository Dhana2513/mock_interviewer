import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constant/text_style.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/columnx.dart';
import 'package:mock_interviewer/core/services/firestore.dart';
import 'package:mock_interviewer/core/services/gen_ai.dart';
import 'package:mock_interviewer/features/study/add_topic.dart';
import 'package:mock_interviewer/features/study/topic_decription_screen.dart';
import 'package:mock_interviewer/shared/models/topic.dart';
import 'package:mock_interviewer/shared/types/topic_type.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> with AutomaticKeepAliveClientMixin {
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
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const AddTopic(),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      );

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
              child: Text('Topics', style: UITextStyle.title),
            ),
            StreamBuilder<List<Topic>>(
                stream: Firestore.instance.topicStream.stream,
                builder: (context, snapshot) {
                  final topics = snapshot.data ?? [];

                  log('dddd : topics : $topics');

                  if (topics.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(BoxPadding.basic),
                        child: Text(
                          'Add a topics by clicking on the add button, your added '
                          'topics will be shown here.',
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

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                         TopicDescriptionScreen(topics: topics,index: index,)));
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
                                onPressed: () =>
                                    Firestore.instance.deleteTopic(topic),
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
  bool get wantKeepAlive => true;
}
