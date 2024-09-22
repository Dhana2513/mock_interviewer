import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mock_interviewer/core/extensions/date_time_extension.dart';
import 'package:mock_interviewer/shared/models/video_details.dart';

class FireStorage {
  static FireStorage instance = FireStorage._();

  FireStorage._() {
    _storage = FirebaseStorage.instance;
  }

  late final FirebaseStorage _storage;

  Future<void> uploadVideo(Future<Uint8List> data) async {
    final result = await data;
    final now = DateTime.now();

    await _storage.ref(now.toFileName).putData(result);
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
