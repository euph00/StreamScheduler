import 'package:googleapis/youtube/v3.dart';

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
}