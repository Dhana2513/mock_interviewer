import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/widgets/main_scafold.dart';
import 'package:mock_interviewer/features/history/history_screen.dart';
import 'package:mock_interviewer/features/interview/interview_screen.dart';
import 'package:mock_interviewer/features/study/study_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottonNavIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: bottonNavIndex);
  }

  void updateIndex(int index) {
    setState(() {
      bottonNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScafold(
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
        currentIndex: bottonNavIndex,
        onTap: (index) {
          updateIndex(index);
          pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), label: 'Study'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_outlined), label: 'Interview'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_history_outlined), label: 'History'),
        ],
      ),
    );
  }
}
