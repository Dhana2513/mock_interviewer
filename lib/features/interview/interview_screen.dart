import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';
import 'package:mock_interviewer/core/constants/text_style.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/columnx.dart';
import 'package:mock_interviewer/core/extensions/ui_navigator.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';
import 'package:mock_interviewer/features/interview/record_interview_screen.dart';
import 'package:mock_interviewer/shared/models/question.dart';

import '../../core/extensions/wrapx.dart';
import '../../core/services/firestore.dart';
import '../../core/services/gen_ai.dart';
import '../../shared/models/topic.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with AutomaticKeepAliveClientMixin {
  final List<List<Topic>> allTopics = [];
  final loadingNotifier = ValueNotifier<bool?>(false);

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    List<Topic> listByTopicType(TopicType type) {
      final topics = Firestore.instance.topics
          .where((tp) => tp.topicType == type)
          .toList();
      final clonedList = <Topic>[];

      for (var topic in topics) {
        clonedList.add(topic.copyWith());
      }

      return clonedList;
    }

    allTopics.clear();
    allTopics.add(listByTopicType(TopicType.other));
    allTopics.add(listByTopicType(TopicType.dart));
    allTopics.add(listByTopicType(TopicType.flutter));
  }

  bool get noTopicsForInterview {
    for (final topics in allTopics) {
      if (topics.isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  void navigateToRecordInterviewScreen(List<Question> questions) {
    UINavigator.push(
        context: context, screen: RecordInterviewScreen(questions: questions));
  }

  void startInterview() async {
    final topics = <Topic>[];
    for (final item in allTopics) {
      topics.addAll(item.where((topic) => topic.selected == true).toList());
    }

    if (topics.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(Constants.selectTopics),
          content: const Text(Constants.selectTopicsForInterview),
          actions: [
            TextButton(
              onPressed: () => UINavigator.pop(context),
              child: const Text(Constants.ok),
            )
          ],
        ),
      );
      return;
    }

    loadingNotifier.value = true;
    final result = await GenAI.instance.getQuestions(topics: topics);
    loadingNotifier.value = false;

    final questions = Question.fromJsonList(jsonList: result);
    navigateToRecordInterviewScreen(questions);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        setData();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(BoxPadding.basic),
        child: ListView(
          children: [
            if (noTopicsForInterview) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(BoxPadding.basic),
                  child: Text(
                    Constants.noTopicsForInterview,
                    style: UITextStyle.bodyLarge,
                  ),
                ),
              )
            ] else ...[
              ColumnX.builder(
                  itemCount: allTopics.length,
                  itemBuilder: (index) {
                    final topics = allTopics[index];

                    if (topics.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topics.first.topicType.stringValue,
                            style: UITextStyle.subtitle,
                          ),
                          const SizedBox(height: BoxPadding.small),
                          WrapX.builder<Topic>(
                            items: topics,
                            itemBuilder: (topic) {
                              return Padding(
                                padding: const EdgeInsets.all(BoxPadding.small),
                                child: FilterChip(
                                  selected: topic.selected ?? false,
                                  selectedColor:
                                      Theme.of(context).primaryColorLight,
                                  onSelected: (value) {
                                    setState(() {
                                      topic.selected = value;
                                    });
                                  },
                                  avatar: Image(image: topic.topicType.image),
                                  label: Text(topic.name),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: BoxPadding.small),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: BoxPadding.medium),
              SizedBox(
                height: BoxPadding.xLarge + BoxPadding.small,
                child: ValueListenableBuilder(
                    valueListenable: loadingNotifier,
                    builder: (context, loading, child) {
                      if (loading == true) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return UIButton(
                        onPressed: startInterview,
                        title: Constants.startInterview,
                      );
                    }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
