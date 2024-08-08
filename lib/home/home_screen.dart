import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/widgets/main_scaffold.dart';
import 'package:mock_interviewer/features/history/history_screen.dart';
import 'package:mock_interviewer/features/interview/interview_screen.dart';
import 'package:mock_interviewer/features/study/study_screen.dart';

import '../core/constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: bottomNavIndex);
  }

  void updateIndex(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => updateIndex(index),
        children: const [
          StudyScreen(),
          InterviewScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavIndex,
        onTap: (index) {
          updateIndex(index);
          pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: Constants.study,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: Constants.interview,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_outlined),
            label: Constants.history,
          ),
        ],
      ),
    );
  }
}
