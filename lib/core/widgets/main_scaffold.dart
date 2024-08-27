import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/text_style.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    this.body,
    this.appBarTitle,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String? appBarTitle;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle ?? Constants.appName,
          style: UITextStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
