import 'dart:collection';

import 'package:flutter/foundation.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';
import 'package:mobx/mobx.dart';
import 'subscription_item.dart';
import 'channel_item.dart';
import 'video_item.dart';
import 'broadcast_item.dart';

class SharedAppState extends ChangeNotifier {
  final SignInController signInController = SignInController();
  final YoutubeDataController youtubeDataController = YoutubeDataController();
  final ObservableList<SubscriptionItem> subscriptions =
      ObservableList<SubscriptionItem>.of(<SubscriptionItem>[]);
  final HashSet<ChannelItem> _trackedChannels = HashSet<ChannelItem>.from(<ChannelItem>[]);
  final ObservableList<BroadcastItem> liveStreams = ObservableList.of(<BroadcastItem>[]);
  final ObservableList<BroadcastItem> upcomingStreams = ObservableList.of(<BroadcastItem>[]);

  // Login

  void login() async {
    signInController.login().then((value) => notifyListeners());
  }

  bool verifyLoginStatus() {
    return signInController.getAuthStatus();
  }

  // Subscriptions

  void updateSubscriptions() async {
    subscriptions.clear();
    subscriptions.addAll((await youtubeDataController.getSubscriptions())
        .map((e) => SubscriptionItem(sub: e)));
  }

  // Filtered channels

  void updateTrackedChannels() async {
    // change to selectively update set with diff only in the future
    _trackedChannels.clear();
    List<String> ids = await Stream.fromIterable(subscriptions)
        .where((item) => item.isChecked)
        .map((item) => item.getChannelId())
        .toList();
    _trackedChannels
        .addAll((await youtubeDataController.getChannelListFromIds(ids)).map((e) => ChannelItem(ch: e)));
    print(_trackedChannels.map((e) => e.getChannelTitle()));
    updateVideoLists();
  }

  // Video resources

  void updateVideoLists() async {
    // change to selectively update set with diff only in the future
    liveStreams.clear();
    upcomingStreams.clear();
    List<String> videoIds = <String>[];
    for (ChannelItem channel in _trackedChannels) {
      videoIds.addAll((await youtubeDataController.getChannelUploadsPlaylistItems(channel)).map((e) => e.snippet!.resourceId!.videoId!));
    }
    List<VideoItem> videos = (await youtubeDataController.getVideosFromVideoIds(videoIds)).map((e) => VideoItem(vid: e)).toList();
    for (VideoItem video in videos) {
      String broadcastStatus = video.getLiveBroadcastContent();
      if (broadcastStatus == 'live') {
        liveStreams.add(BroadcastItem(vid: video.vid));
      } else if (broadcastStatus == 'upcoming') {
        upcomingStreams.add(BroadcastItem(vid: video.vid));
      } else if (broadcastStatus == 'none') {
        continue;
      } else {
        print("this video has unusual status $broadcastStatus: ${video.getVideoTitle()}");
        continue;
      }
    }

    print("__________________________LIVE__________________________");
    for (BroadcastItem item in liveStreams) {
      print(item.getVideoTitle());
    }
    print("__________________________UPCOMING__________________________");
    for (BroadcastItem item in upcomingStreams) {
      print(item.getVideoTitle());
    }
  }

  void _testFunction() {
    var sub = subscriptions[1];
    var channelId = sub.getChannelId();
    youtubeDataController.test(channelId);
  }
}
