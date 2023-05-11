import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../controller/sign_in_controller.dart';
import '../controller/youtube_data_controller.dart';
import 'subscription_item.dart';
import 'channel_item.dart';
import 'video_item.dart';
import 'broadcast_item.dart';
import 'filtered_sorted_observable_list.dart';
import '../../main.dart';
import '../controller/storage_controller.dart';

class SharedAppState extends ChangeNotifier {
  bool isColdBoot = true;
  bool _trackedChannelsNeedsInit = true;
  final SignInController signInController = SignInController();
  final YoutubeDataController youtubeDataController = YoutubeDataController();
  final StorageController storageController = StorageController();
  final Set<SubscriptionItem> subscriptions = HashSet<SubscriptionItem>();
  final FilteredSortedObservableList<SubscriptionItem> displayedSubscriptions =
      FilteredSortedObservableList<SubscriptionItem>();
  final Set<ChannelItem> _trackedChannels = HashSet<ChannelItem>();
  final List<BroadcastItem> liveStreams = <BroadcastItem>[];
  final FilteredSortedObservableList<BroadcastItem> displayedLiveStreams =
      FilteredSortedObservableList<BroadcastItem>.withComparator((a, b) => a
          .getActualStartTime()
          .compareTo(
              b.getActualStartTime())); // default early to late comparator
  final List<BroadcastItem> upcomingStreams = <BroadcastItem>[];
  final FilteredSortedObservableList<BroadcastItem> displayedUpcomingStreams =
      FilteredSortedObservableList<BroadcastItem>.withComparator((a, b) => a
          .getActualStartTime()
          .compareTo(
              b.getActualStartTime())); // default early to late comparator
  final FilteredSortedObservableList<BroadcastItem> homePageList =
      FilteredSortedObservableList();

  // Login

  void login() async {
    signInController.login().then((value) => notifyListeners());
  }

  bool verifyLoginStatus() {
    return signInController.getAuthStatus();
  }

  // Logout

  void reset(BuildContext context) {
    // reset controllers
    signInController.reset();
    youtubeDataController.reset();
    _trackedChannelsNeedsInit = true;

    // reset states
    subscriptions.clear();
    displayedSubscriptions.reset();
    _trackedChannels.clear();
    liveStreams.clear();
    displayedLiveStreams.reset();
    upcomingStreams.clear();
    displayedUpcomingStreams.reset();

    // reset pages
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StreamScheduler()),
        (route) => false);
  }

  // Subscriptions

  Future<void> updateSubscriptions() async {
    Iterable<SubscriptionItem> freshData =
        (await youtubeDataController.getSubscriptions())
            .map((e) => SubscriptionItem(sub: e));
    for (SubscriptionItem item in freshData) {
      if (!subscriptions.contains(item)) subscriptions.add(item);
    }
    Set freshDataSet = HashSet.from(freshData);
    for (SubscriptionItem item in subscriptions.toList()) {
      if (!freshDataSet.contains(item)) subscriptions.remove(item);
    }
    if (_trackedChannelsNeedsInit) {
      await _initTrackedChannels();
      _trackedChannelsNeedsInit = false;
    }
    displayedSubscriptions.clear();
    displayedSubscriptions.addAll(subscriptions);
  }

  Future<void> _initTrackedChannels() async {
    Set<String> savedTrackedChannelIds =
        await storageController.retrieveTrackedChannels();
    List<String> newSavedTrackedChannelIds = <String>[];
    for (SubscriptionItem item in subscriptions) {
      if (savedTrackedChannelIds.contains(item.getChannelId())) {
        item.setCheck(true);
        newSavedTrackedChannelIds.add(item.getChannelId());
      }
    }
    storageController.saveTrackedChannelsById(newSavedTrackedChannelIds);
    displayedSubscriptions.clear();
    displayedSubscriptions.addAll(subscriptions);
  }

  // Filtered channels

  Future<void> updateTrackedChannels() async {
    _trackedChannels.clear();
    List<String> ids = await Stream.fromIterable(subscriptions)
        .where((item) => item.isChecked)
        .map((item) => item.getChannelId())
        .toList();
    if (ids.isNotEmpty) {
      _trackedChannels.addAll(
          (await youtubeDataController.getChannelListFromIds(ids))
              .map((e) => ChannelItem(ch: e)));
    }
    print(_trackedChannels.map((e) => e.getChannelTitle()));
    storageController.saveTrackedChannels(_trackedChannels);
  }

  // Video resources

  Future<void> updateVideoLists() async {
    liveStreams.clear();
    upcomingStreams.clear();
    List<String> videoIds = <String>[];
    for (ChannelItem channel in _trackedChannels) {
      videoIds.addAll(
          (await youtubeDataController.getChannelUploadsPlaylistItems(channel))
              .map((e) => e.snippet!.resourceId!.videoId!));
    }
    List<VideoItem> videos =
        (await youtubeDataController.getVideosFromVideoIds(videoIds))
            .map((e) => VideoItem(vid: e))
            .toList();
    liveStreams.addAll(await Stream.fromIterable(videos)
        .where((video) => video.getLiveBroadcastContent() == 'live')
        .map((video) => BroadcastItem(vid: video.vid))
        .toList());
    displayedLiveStreams.clear();
    displayedLiveStreams.addAll(liveStreams);
    upcomingStreams.addAll(await Stream.fromIterable(videos)
        .where((video) => video.getLiveBroadcastContent() == 'upcoming')
        .map((video) => BroadcastItem(vid: video.vid))
        .toList());
    displayedUpcomingStreams.clear();
    displayedUpcomingStreams.addAll(upcomingStreams);
    homePageList.clear();
    homePageList.addAll(liveStreams);
    homePageList.addAll(upcomingStreams);

    print("__________________________LIVE__________________________");
    for (BroadcastItem item in liveStreams) {
      print(item.getVideoTitle());
    }
    print("__________________________UPCOMING__________________________");
    for (BroadcastItem item in upcomingStreams) {
      print(item.getVideoTitle());
    }
  }
}
