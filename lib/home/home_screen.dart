import 'package:flutter/material.dart';
import 'package:mock_interviewer/common/main_scafold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return MainScafold(
      body: Container(),
    );
  }
}