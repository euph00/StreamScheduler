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

  // Channel ID is guaranteed to be unique.
  // 2 channels with the same ID must be the same channel.
  @override
  int get hashCode => getChannelId().hashCode;

  @override
  bool operator ==(Object other) {
    return other is ChannelItem &&
      other.getChannelId() == getChannelId();
  }
}
