import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mock_interviewer/core/constants/text_style.dart';
import 'package:mock_interviewer/core/extensions/ui_navigator.dart';
import 'package:mock_interviewer/core/services/fire_storage.dart';
import 'package:mock_interviewer/core/widgets/main_scaffold.dart';
import 'package:mock_interviewer/core/widgets/ui_button.dart';

import '../../core/constants/constants.dart';
import '../../core/extensions/box_padding.dart';
import '../../shared/models/question.dart';

class RecordInterviewScreen extends StatefulWidget {
  const RecordInterviewScreen({super.key, required this.questions});

  final List<Question> questions;

  @override
  State<RecordInterviewScreen> createState() => _RecordInterviewScreenState();
}

class _RecordInterviewScreenState extends State<RecordInterviewScreen> {
  late List<CameraDescription> _cameras;
  CameraController? controller;
  late FlutterTts flutterTts;
  final loadingNotifier = ValueNotifier<bool>(false);
  final loadingDotsNotifier = ValueNotifier<int>(1);

  @override
  void initState() {
    super.initState();
    initVideoRecording();
    initTTS();
  }

  void initVideoRecording() async {
    _cameras = await availableCameras();

    controller = CameraController(
      _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.max,
      enableAudio: true,
    );
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller?.startVideoRecording();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void initTTS() {
    flutterTts = FlutterTts();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        speak(widget.questions[questionIndex].question);
      },
    );
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future<void> tick() async {
    if (loadingDotsNotifier.value < 3) {
      loadingDotsNotifier.value++;
    } else {
      loadingDotsNotifier.value = 1;
    }

    try {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (mounted) {
            tick();
          }
        },
      );
    } on Exception catch (_) {}
  }

  void stopRecording() async {
    loadingNotifier.value = true;
    tick();
    final result = await controller?.stopVideoRecording();
    if (result != null) {
      await FireStorage.instance.uploadVideo(result.readAsBytes());
    }
    loadingNotifier.value = false;
    popScreen();
  }

  void popScreen() {
    UINavigator.pop(context);
  }

  int questionIndex = 0;

  Widget textView(String text) {
    return Container(
      margin: const EdgeInsets.all(BoxPadding.medium),
      padding: const EdgeInsets.all(BoxPadding.medium),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(BoxPadding.small)),
      child: Text(
        text,
        style: UITextStyle.body.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBarTitle: Constants.interview,
      body: controller == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox.expand(
              child: CameraPreview(
                controller!,
                child: Stack(
                  children: [
                    Positioned(
                        top: BoxPadding.large,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            textView(widget.questions[questionIndex].question),
                            if (questionIndex < widget.questions.length - 1)
                              UIButton(
                                  onPressed: () {
                                    questionIndex++;
                                    speak(widget
                                        .questions[questionIndex].question);
                                    setState(() {});
                                  },
                                  title: Constants.next)
                          ],
                        )),
                    Positioned(
                      bottom: BoxPadding.large,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: loadingNotifier,
                          builder: (context, loading, child) {
                            if (loading) {
                              return ValueListenableBuilder<int>(
                                valueListenable: loadingDotsNotifier,
                                builder: (context, index, child) {
                                  String dots = '';
                                  for (int i = 1; i <= index; i++) {
                                    dots += '.';
                                  }

                                  return textView(
                                      '${Constants.uploadingInterview} $dots');
                                },
                              );
                            }
                            return InkWell(
                              onTap: stopRecording,
                              child: const Padding(
                                padding: EdgeInsets.all(BoxPadding.medium),
                                child: Icon(
                                  Icons.stop_circle_outlined,
                                  color: Colors.redAccent,
                                  size: BoxPadding.xxLarge + BoxPadding.basic,
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
