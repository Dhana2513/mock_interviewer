import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
      return const Center(
      child: Text(Constants.interview),
    );
  }

    @override
  bool get wantKeepAlive => true;
}