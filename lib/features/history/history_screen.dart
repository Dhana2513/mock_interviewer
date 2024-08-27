import 'package:flutter/material.dart';
import 'package:mock_interviewer/core/extensions/box_padding.dart';
import 'package:mock_interviewer/core/extensions/ui_navigator.dart';
import 'package:mock_interviewer/core/services/fire_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/text_style.dart';
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
    getData();
  }

  void getData() {
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

  void deleteVideo(VideoDetails video) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(Constants.deleteVideo),
              content: Text(
                Constants.deleteVideoMessage
                    .replaceAll('<<video>>', video.name),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await FireStorage.instance.deleteVideo(video);
                      getData();
                      setState(() {});
                    });

                    UINavigator.pop(context);
                  },
                  child: const Text(Constants.delete),
                ),
                TextButton(
                  onPressed: () => UINavigator.pop(context),
                  child: const Text(Constants.cancel),
                ),
              ],
            ));
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
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data?.isEmpty == true) {
              return ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(BoxPadding.large),
                    child: Text(
                      Constants.noInterviewHistory,
                      style: UITextStyle.bodyLarge,
                    ),
                  ),
                ],
              );
            }

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
                    trailing: IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.delete),
                      ),
                      onPressed: () => deleteVideo(video),
                    ),
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
