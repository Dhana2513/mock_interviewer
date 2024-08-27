import 'package:firebase_storage/firebase_storage.dart';

class VideoDetails {
  const VideoDetails({
    required this.reference,
    required this.name,
    required this.path,
  });

  final Reference reference;
  final String name;
  final String path;
}
