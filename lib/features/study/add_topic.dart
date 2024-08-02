import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constant/asset_images.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/text_size.dart';
import 'package:mock_interviewer/core/services/firestore.dart';
import 'package:mock_interviewer/core/services/gen_ai.dart';

import '../../shared/models/topic.dart';
import '../../shared/types/topic_type.dart';

class AddTopic extends StatefulWidget {
  const AddTopic({super.key});

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  final topicNameController = TextEditingController();

  bool flutterSelected = true;
  bool dartSelected = false;
  bool otherSelected = false;

  bool loading = false;

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BoxPadding.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: BoxPadding.xSmall),
          Text(
            'Add Topic',
            style: TextStyle(
              fontSize: TextSize.large,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: BoxPadding.large),
          TextField(
            focusNode: focusNode,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Topic Name'),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            controller: topicNameController,
          ),
          const SizedBox(height: BoxPadding.basic),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterChip(
                selected: flutterSelected,
                label: const Text('Flutter'),
                avatar: Image(image: AssetImages.shared.flutter),
                onSelected: (selected) {
                  flutterSelected = true;
                  dartSelected = false;
                  otherSelected = false;
                  setState(() {});
                },
              ),
              FilterChip(
                selected: dartSelected,
                label: const Text('Dart'),
                avatar: Image(image: AssetImages.shared.dart),
                onSelected: (selected) {
                  flutterSelected = false;
                  dartSelected = true;
                  otherSelected = false;
                  setState(() {});
                },
              ),
              FilterChip(
                selected: otherSelected,
                label: const Text('Other'),
                avatar: Image(image: AssetImages.shared.curly),
                onSelected: (selected) {
                  flutterSelected = false;
                  dartSelected = false;
                  otherSelected = true;
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: BoxPadding.large),
          if (loading)
            const CircularProgressIndicator()
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {
                  final topicName = topicNameController.text.trim();
                  final topicType = flutterSelected
                      ? TopicType.flutter
                      : dartSelected
                          ? TopicType.dart
                          : TopicType.other;

                  if (topicName.isEmpty) return;

                  focusNode.unfocus();

                  setState(() {
                    loading = true;
                  });
                  
                  final topic = Topic(name: topicName, topicType: topicType);

                  final desciption =
                      await GenAI.instance.topicResponse(topic: topic);
                  topic.description = desciption;

                  await Firestore.instance.addTopic(topic);

                  setState(() {
                    loading = false;
                  });

                  popDialog();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          const SizedBox(
            height: BoxPadding.basic,
          )
        ],
      ),
    );
  }

  void popDialog() {
    Navigator.of(context).pop();
  }
}
