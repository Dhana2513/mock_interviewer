import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/constants/constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Center(
      child: Text(Constants.history),
    );
  }

    @override
  bool get wantKeepAlive => true;
}
