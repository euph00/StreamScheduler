import 'dart:collection';
import 'dart:math';

import 'package:googleapis/youtube/v3.dart';
import 'package:streamscheduler/src/model/channel_item.dart';
import 'sign_in_controller.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class YoutubeDataController {
  YouTubeApi? youTubeApi;
  SignInController? signInController;
  late String? _id;
  static final YoutubeDataController _singletonInstance =
      YoutubeDataController._internal();
  final Map<String, Channel> channelCache = HashMap();

  static const int maxQueryBatchSize = 50;
  static const int perChannelQueryDepth = 20;

  factory YoutubeDataController() {
    return _singletonInstance;
  }
  YoutubeDataController._internal();

  void reset() {
    youTubeApi = null;
    _id = null;
    channelCache.clear();
  }

  void initialiseYoutubeApi(SignInController signInController) async {
    var httpClient =
        (await signInController.getGsiInstance().authenticatedClient())!;
    youTubeApi = YouTubeApi(httpClient);
    this.signInController = signInController;
    _id = (await youTubeApi!.channels.list(['id'], mine: true)).items![0].id!;
  }

  void clearCredentials() {
    youTubeApi = null;
    signInController = null;
  }

  Future<List<Subscription>> getSubscriptions() async {
    if (signInController == null) {
      print('NOT SIGNED IN');
    }
    var subs = <Subscription>[];
    var response = (await youTubeApi!.subscriptions.list(
        ['snippet', 'contentDetails'],
        channelId: _id, maxResults: maxQueryBatchSize));
    for (int i = 0; i < 10; i++) {
      //currently support up to 500 subbed channels, due to api quotas
      for (var item in response.items!) {
        subs.add(item);
      }
      if (response.nextPageToken == null) break;
      response = (await youTubeApi!.subscriptions.list(['snippet'],
          channelId: _id,
          maxResults: maxQueryBatchSize,
          pageToken: response.nextPageToken));
    }
    return subs;
  }

  Future<List<Channel>> getChannelListFromIds(List<String> ids) async {
    List<String> queryList = <String>[];
    List<Channel> resultList = <Channel>[];
    for (String id in ids) {
      if (channelCache.containsKey(id)) {
        resultList.add(channelCache[id]!);
      } else {
        queryList.add(id);
      }
    }
    print(queryList.length);
    if (queryList.isNotEmpty) {
      List<Channel> response = (await youTubeApi!.channels
              .list(['snippet', 'contentDetails'], id: queryList))
          .items!;
      for (Channel ch in response) {
        channelCache[ch.id!] = ch;
        resultList.add(ch);
      }
    }
    return resultList;
  }

  Future<List<PlaylistItem>> getChannelUploadsPlaylistItems(
      ChannelItem channel) async {
    // gets top perChannelQueryDepth items from the playlist, as most likely all livestreams/
    // waiting rooms are in the top n items. API quota consideration.
    String uploadsPlaylistId = channel.getUploadsPlaylistId();
    return (await youTubeApi!.playlistItems.list(['snippet'],
            maxResults: perChannelQueryDepth, playlistId: uploadsPlaylistId))
        .items!;
  }

  Future<List<Video>> getVideosFromVideoIds(List<String> videoIds) async {
    List<Video> videos = <Video>[];
    if (videoIds.isEmpty) return Future(() => videos);
    int queryEnd = min(maxQueryBatchSize, videoIds.length);
    int queryStart = 0;
    while (queryEnd <= videoIds.length) {
      List<String> queryList = videoIds.sublist(queryStart, queryEnd);
      VideoListResponse response = await youTubeApi!.videos
          .list(['snippet', 'id', 'liveStreamingDetails'], id: queryList);
      videos.addAll(response.items!);
      if (queryEnd == videoIds.length) {
        break;
      }
      queryStart += maxQueryBatchSize;
      queryEnd = min(queryEnd + maxQueryBatchSize, videoIds.length);
    }
    print(videos.length);
    return videos;
  }
}
