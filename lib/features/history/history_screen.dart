import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/services/fire_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/models/video_details.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<VideoDetails>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = FireStorage.instance.getAllVideos();
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        futureVideos = FireStorage.instance.getAllVideos();
        setState(() {});
      },
      child: FutureBuilder(
          future: futureVideos,
          builder: (context, snapshot) {
            final videos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: BoxPadding.basic,
                    vertical: BoxPadding.xxSmall,
                  ),
                  color: Colors.white,
                  child: ListTile(
                    onTap: () => launchInBrowser(Uri.parse(video.path)),
                    leading: const Icon(Icons.play_circle_outline_rounded),
                    title: Text(video.name),
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
