import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../extensions/text_size.dart';

class MainScafold extends StatelessWidget {
  const MainScafold({
    super.key,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constants.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: TextSize.large,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
