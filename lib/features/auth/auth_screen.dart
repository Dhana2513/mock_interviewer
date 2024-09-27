import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/services/local_storage.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';
import 'package:mock_interviewer/features/home/home_screen.dart';

import '../../core/constants/asset_images.dart';
import '../../core/constants/constants.dart';
import '../../core/widgets/main_scaffold.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final FirebaseAuth auth;
  final loginValueNotifier = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
    checkIfUserHasLoggedIn();
    auth = FirebaseAuth.instanceFor(app: Firebase.app());
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await auth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (error) {
      log(error.toString());
    }

    return null;
  }

  Future<void> checkIfUserHasLoggedIn() async {
    final userName = await LocalStorage.instance.getUserName();
    loginValueNotifier.value = userName?.isNotEmpty == true;
  }

  void onLoginButtonTap() async {
    loginValueNotifier.value == null;

    final user = await signInWithGoogle();
    await LocalStorage.instance.setUserName(userName: user?.email ?? 'default');

    loginValueNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loginValueNotifier,
      builder: (context, loggedIn, child) {
        if (loggedIn == true) {
          return const HomeScreen();
        }

        return MainScaffold(
          body: loggedIn == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(BoxPadding.large),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImages.shared.appIcon),
                      const SizedBox(height: BoxPadding.xxLarge),
                      SizedBox(
                        width: BoxPadding.xxLarge * 3,
                        child: UIButton(
                          onPressed: onLoginButtonTap,
                          title: Constants.login,
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
