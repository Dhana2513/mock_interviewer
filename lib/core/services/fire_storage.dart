import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mock_interviewer/core/extensions/date_time_extension.dart';
import 'package:mock_interviewer/shared/models/question.dart';
import 'package:mock_interviewer/shared/models/video_details.dart';

import 'firestore.dart';

class FireStorage {
  static FireStorage instance = FireStorage._();

  FireStorage._() {
    _storage = FirebaseStorage.instance;
  }

  late final FirebaseStorage _storage;

  Future<void> uploadVideo({
    required List<Question> questions,
    required Future<Uint8List> data,
  }) async {
    final result = await data;
    final fileName = DateTime.now().toFileName;

    await _storage.ref(fileName).putData(result);
    await Firestore.instance.addQuestions(
      fileName: fileName,
      questions: questions,
    );
  }

  Future<List<VideoDetails>> getAllVideos() async {
    ListResult result = await _storage.ref().listAll();
    final videos = <VideoDetails>[];

    for (final ref in result.items) {
      videos.add(VideoDetails(
        reference: ref,
        name: ref.name,
        path: await ref.getDownloadURL(),
      ));
    }

    return videos;
  }

  Future<void> deleteVideo(VideoDetails videoDetails) async {
    await videoDetails.reference.delete();
  }
}
