import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';

class VoiceTest extends StatefulWidget {
  const VoiceTest({super.key});

  @override
  State<VoiceTest> createState() => _VoiceTestState();
}

class _VoiceTestState extends State<VoiceTest> {

  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    flutterTts = FlutterTts();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    final voices = await flutterTts.getVoices;

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  // Future<void> _setAwaitOptions() async {
  //   await flutterTts.awaitSpeakCompletion(true);
  // }

  Future<void> stopTalking() async {
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UIButton(
        onPressed: (){
          speak('Hello Shitij. How are you?. Can we start your interview.');
        },
        title: 'Speak',
      ),
    );
  }
}
