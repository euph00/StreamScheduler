import 'package:googleapis/youtube/v3.dart';

class ChannelItem {
  ChannelItem({
    required this.ch,
  });

  final Channel ch;

  String getUploadsPlaylistId() {
    return ch.contentDetails!.relatedPlaylists!.uploads!;
  }

  String getChannelId() {
    return ch.id!;
  }

  String getChannelTitle() {
    return ch.snippet!.title!;
  }
}