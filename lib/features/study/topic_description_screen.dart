import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mock_interviewer/core/widgets/main_scaffold.dart';

import '../../shared/models/topic.dart';

class TopicDescriptionScreen extends StatefulWidget {
  const TopicDescriptionScreen({
    super.key,
    required this.topics,
    required this.index,
  });

  final List<Topic> topics;
  final int index;

  @override
  State<TopicDescriptionScreen> createState() => _TopicDescriptionScreenState();
}

class _TopicDescriptionScreenState extends State<TopicDescriptionScreen> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    log('dddd : index ${widget.index}');

    pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: widget.topics
          .map((topic) => MainScaffold(
                appBarTitle: topic.name,
                body: Markdown(
                  data: topic.description ?? '',
                ),
              ))
          .toList(),
    );
  }
}
