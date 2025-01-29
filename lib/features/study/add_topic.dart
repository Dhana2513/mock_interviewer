import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/text_style.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/text_size.dart';
import 'package:mock_interviewer/core/services/firestore.dart';
import 'package:mock_interviewer/core/services/gen_ai.dart';
import 'package:mock_interviewer/core/services/local_storage.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';

import '../../core/constants/constants.dart';
import '../../shared/models/topic.dart';

class AddTopic extends StatefulWidget {
  const AddTopic({super.key});

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  final topicNameController = TextEditingController();
  final loadingNotifier = ValueNotifier<bool?>(false);
  final focusNode = FocusNode();
  int selectedTypeIndex = 0;

  List<TopicType> topicTypes = [
    TopicType.android,
    TopicType.kotlin,
    TopicType.flutter,
    TopicType.dart,
    TopicType.other
  ];

  @override
  void initState() {
    super.initState();
    if (LocalStorage.instance.userName.toLowerCase().contains('kshitij')) {
      topicTypes = [
        TopicType.flutter,
        TopicType.dart,
        TopicType.android,
        TopicType.kotlin,
        TopicType.other
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BoxPadding.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: BoxPadding.xSmall),
          Text(
            Constants.addTopic,
            style: TextStyle(
              fontSize: TextSize.large,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: BoxPadding.large,
              bottom: BoxPadding.basic,
              left: BoxPadding.large,
              right: BoxPadding.large,
            ),
            child: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: Constants.topicName),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
              controller: topicNameController,
            ),
          ),
          Wrap(
            children: [
              for (int index = 0; index < topicTypes.length; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: BoxPadding.xxxSmall),
                  child: FilterChip(
                    selected: selectedTypeIndex == index,
                    label: Text(topicTypes[index].stringValue),
                    avatar: Image(image: topicTypes[index].image),
                    onSelected: (selected) {
                      if (selected) {
                        selectedTypeIndex = index;
                      }
                      setState(() {});
                    },
                  ),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(BoxPadding.large),
            child: SizedBox(
              height: BoxPadding.xLarge + BoxPadding.small,
              child: ValueListenableBuilder(
                valueListenable: loadingNotifier,
                builder: (context, loading, child) {
                  if (loading == null) {
                    return Center(
                      child: Text(
                        Constants.errorOccurred,
                        style: UITextStyle.body.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (loading == true) {
                    return const CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      child: UIButton(
                        onPressed: () async {
                          final topicName = topicNameController.text.trim();
                          final topicType = topicTypes[selectedTypeIndex];

                          if (topicName.isEmpty) return;

                          focusNode.unfocus();
                          loadingNotifier.value = true;

                          final topic = Topic(
                            name: topicName,
                            topicType: topicType,
                          );

                          final description =
                              await GenAI.instance.topicResponse(topic: topic);
                          if (description.isNotEmpty) {
                            topic.description = description;
                            await Firestore.instance.addTopic(topic);
                            loadingNotifier.value = false;
                            popDialog();
                          } else {
                            loadingNotifier.value = null;
                          }
                        },
                        title: Constants.submit,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void popDialog() {
    Navigator.of(context).pop();
  }
}
