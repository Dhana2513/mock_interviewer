import 'package:flutter/material.dart';
import 'package:mock_interviewer/constant/constants.dart';

class MainScafold extends StatelessWidget {
  const MainScafold({
    super.key,
    this.body,
    this.floatingActionButton,
  });

  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
