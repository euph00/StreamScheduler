import 'package:googleapis/youtube/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoItem {
  VideoItem({
    required this.vid,
  });

  final Video vid;

  String getLiveBroadcastContent() {
    return vid.snippet!.liveBroadcastContent!;
  }

  String getVideoTitle() {
    return vid.snippet!.title!;
  }

  String getChannelTitle() {
    return vid.snippet!.channelTitle!;
  }

  String getChannelId() {
    return vid.snippet!.channelId!;
  }

  String getThumbnailUrl() {
    return vid.snippet!.thumbnails!.medium!.url!;
  }

  String getVideoUrl() {
    return "https://www.youtube.com/watch?v=${vid.id}";
  }

  Future<void> launchVideoUrl() async {
    Uri url = Uri.parse(getVideoUrl());
    if (!await launchUrl(url)) {
      throw Exception("Could not launch $url");
    }
  }
}
